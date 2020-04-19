import * as crypto from "crypto";
import { NextFunction, Request, Response, Router } from "express";
import { inject, injectable } from "inversify";
import * as pg from "pg";
import { REGEXP_EMAIL_PATTERN, REGEXP_PASSWD_PATTERN } from '../../../common/models/patterns';
import { Filme } from './../../../common/tables/filme';
import { Membre } from './../../../common/tables/membre';

import { DatabaseService } from "../services/database.service";
import Types from "../types";

const OK: number = 200;
const NOT_FOUND: number = 404;

@injectable()
export class DatabaseController {
    public constructor(@inject(Types.DatabaseService) private databaseService: DatabaseService) { }

    public get router(): Router {
        const router: Router = Router();

        router.post("/createSchema",
                    (req: Request, res: Response, next: NextFunction) => {
                    this.databaseService.createSchema().then((result: pg.QueryResult) => {
                        res.json(result);
                    }).catch((e: Error) => {
                        console.error(e.stack);
                    });
                });

        router.post("/populateDb",
                    (req: Request, res: Response, next: NextFunction) => {
                    this.databaseService.populateDb().then((result: pg.QueryResult) => {
                        res.json(result);
                    }).catch((e: Error) => {
                        console.error(e.stack);
                    });
        });

        router.post("/login", (req: Request, res: Response, next: NextFunction) => {
            if (this.validateEntry(req.body.email, req.body.password)) {
                this.databaseService.loginUser(req.body.email, req.body.password)
                .then((queryResult: pg.QueryResult<pg.QueryResultRow>) => {
                    if (queryResult.rowCount !== 0) {
                        const pswd: string = queryResult.rows[0]['motdepasse'];
                        const hashPaswd: string = crypto.createHash('sha256').update(req.body.password).digest('hex');
                        if (hashPaswd === pswd) {
                            res.status(OK).send(this.setupMember(queryResult.rows));
                        } else {
                            res.status(NOT_FOUND).send(NOT_FOUND);
                        }
                    } else {
                        res.status(NOT_FOUND).send(NOT_FOUND);
                    }
                })
                .catch((err: Error) => {
                    console.log(err);
                    res.status(NOT_FOUND).send(NOT_FOUND);
                });
        } else {
                res.status(NOT_FOUND).send();
            }
        });

        router.get("/admin/:id", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.id === -1) {
                console.log('not here');
                res.status(NOT_FOUND).send(false);
            } else {
                this.databaseService.checkIfAdmin(req.params.id)
                .then((result: pg.QueryResult) => {
                    res.status(OK).send(result.rows[0]['estadmin']);
                }).catch((e: Error) => {
                    res.status(NOT_FOUND).send(false);
                    console.error(e.stack);
                });
            }
        });

        router.get("/members/all", (req: Request, res: Response, next: NextFunction) => {
            this.databaseService.getAllUsers()
            .then((result: pg.QueryResult) => {
                const members: Membre[] = result.rows.map((row: pg.QueryResultRow) => ({
                    id_membre: row.id_membre,
                    courriel: row.courriel,
                    nom: row.nom,
                    rue: row.rue,
                    ville: row.ville,
                    codepostal: row.codepostal,
                    motdepasse: '',
                    estAdmin: row.estadmin
                }));
                res.status(OK).send(members);
            }).catch((e: Error) => {
                res.status(NOT_FOUND).send(false);
                console.error(e.stack);
            });
        });

        router.get("/movies/all", (req: Request, res: Response, next: NextFunction) => {
            this.databaseService.getAllMovies()
            .then((result: pg.QueryResult<pg.QueryResultRow>) => {
                const movies: Filme[] = result.rows.map((row: pg.QueryResultRow) => ({
                    noFilme: row.nofilme,
                    titre: row.titre,
                    genre: row.genre,
                    duree: row.duree,
                    date_production: row.date_production
                }));
                res.status(OK).send(movies);
            })
            .catch((error: Error) => {
                res.status(NOT_FOUND).send(error);
            });
        });

        router.delete("/delete/movie/:id", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.id === -1) {
                res.status(NOT_FOUND).send(false);
            } else {
                this.databaseService.deleteMovie(req.params.id)
                .then((result: pg.QueryResult) => {
                    console.log(result);
                    res.status(OK).send();
                }).catch((e: Error) => {
                    res.status(NOT_FOUND).send(false);
                    console.error(e.stack);
                });
            }
        });

        router.delete("/delete/member/:id", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.id === -1) {
                res.status(NOT_FOUND).send(false);
            } else {
                this.databaseService.deleteMember(req.params.id)
                .then((result: pg.QueryResult) => {
                    console.log(result);
                    res.status(OK).send();
                }).catch((e: Error) => {
                    res.status(NOT_FOUND).send(false);
                    console.error(e.stack);
                });
            }
        });


        return router;
    }

    private setupMember(rows: pg.QueryResultRow): Membre {
        return {
            id_membre: rows[0]["id_membre"],
            courriel: rows[0]["courriel"],
            motdepasse: rows[0]["motdepasse"],
            nom: rows[0]["nom"],
            rue: rows[0]["rue"],
            ville: rows[0]["ville"],
            codepostal: rows[0]["codepostal"],
            estAdmin: rows[0]["estadmin"]
        };
    }

    private validateEntry (email: string, password: string): boolean {
        if (REGEXP_EMAIL_PATTERN.test(email)) {
            if (REGEXP_PASSWD_PATTERN.test(password)) {
                console.log('password and email validated');

                return true;
            }
        }

        return false;
    }
}
