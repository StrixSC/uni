import * as crypto from "crypto";
import { NextFunction, Request, Response, Router } from "express";
import * as httpCodes from "http-status-codes";
import { inject, injectable } from "inversify";
import * as pg from "pg";
import {REGEXP_CITY_PATTERN, REGEXP_DATE_PATTERN, REGEXP_EMAIL_PATTERN, REGEXP_FILTER, REGEXP_NAME_PATTERN,
        REGEXP_PASSWD_PATTERN, REGEXP_POSTAL_CODE_PATTERN, REGEXP_TIME_PATTERN } from '../../../common/utils/patterns';
import { Filme } from './../../../common/tables/filme';
import { Membre } from './../../../common/tables/membre';

import { DatabaseService } from "../services/database.service";
import Types from "../types";

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
                    console.log(queryResult.rowCount);
                    if (queryResult.rowCount !== 0) {
                        const pswd: string = queryResult.rows[0]['motdepasse'];
                        const hashPaswd: string = crypto.createHash('sha256').update(req.body.password).digest('hex');
                        if (hashPaswd === pswd) {
                            res.status(httpCodes.OK).send(this.setupMember(queryResult.rows));
                        } else {
                            res.sendStatus(httpCodes.UNAUTHORIZED);
                        }
                    } else {
                        res.sendStatus(httpCodes.NOT_FOUND);
                    }
                })
                .catch((err: Error) => {
                    console.log(err);
                    res.sendStatus(httpCodes.INTERNAL_SERVER_ERROR);
                });
        } else {
                res.sendStatus(httpCodes.BAD_REQUEST);
            }
        });

        router.post("/add/movie", (req: Request, res: Response, next: NextFunction) => {
            if (!this.sanitizeFilm(req.body)) {
                console.log("validated");
                res.sendStatus(httpCodes.BAD_REQUEST);
            } else {
                this.databaseService.addFilm(req.body)
                .then((response: pg.QueryArrayResult) => {
                    res.status(httpCodes.OK);
                    res.send({
                        status: httpCodes.OK
                    });
                })
                .catch((err: Error) => {
                    res.sendStatus(httpCodes.INTERNAL_SERVER_ERROR);
                });
            }
        });

        router.post("/add/member", (req: Request, res: Response, next: NextFunction) => {
            if (!this.sanitizeMember(req.body)) {
                res.status(httpCodes.BAD_REQUEST);
                res.send();
            } else {
                this.databaseService.addMember(req.body)
                .then((response: pg.QueryArrayResult) => {
                    console.log(response);
                    res.status(httpCodes.OK);
                    res.send({
                        status: httpCodes.OK
                    });
                })
                .catch((err: Error) => {
                    if (err.message === 'duplicate key value violates unique constraint "membre_courriel_key"') {
                        res.send({
                            status: httpCodes.CONFLICT
                        });
                    } else {
                        res.sendStatus(httpCodes.INTERNAL_SERVER_ERROR);
                    }
                });
            }
        });

        router.patch("/update/movie", (req: Request, res: Response, next: NextFunction) => {
            if (!this.sanitizeFilm(req.body)) {
                res.status(httpCodes.BAD_REQUEST);
                res.send();
            } else {
                this.databaseService.updateFilm(req.body)
                .then((response: pg.QueryArrayResult) => {
                    res.status(httpCodes.OK);
                    res.send({
                        status: httpCodes.OK
                    });
                })
                .catch((err: Error) => {
                    console.log(err);
                    res.sendStatus(httpCodes.INTERNAL_SERVER_ERROR);
                });
            }
        });
        router.get("/admin/:id", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.id === -1) {
                res.status(httpCodes.NOT_FOUND).send(false);
            } else {
                this.databaseService.checkIfAdmin(req.params.id)
                .then((result: pg.QueryResult) => {
                    res.status(httpCodes.OK).send({result: result.rows[0]['estadmin']});
                }).catch((e: Error) => {
                    res.status(httpCodes.NOT_FOUND).send(false);
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
                res.status(httpCodes.OK).send(members);
            }).catch((e: Error) => {
                res.status(httpCodes.NOT_FOUND).send(false);
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
                res.status(httpCodes.OK).send(movies);
            })
            .catch((error: Error) => {
                res.status(httpCodes.NOT_FOUND).send(error);
            });
        });

        router.get("/movies/:id", (req: Request, res: Response, next: NextFunction) => {
            this.databaseService.getFilmInfo(req.params.id)
            .then((result: pg.QueryResultRow[]) => {
                res.status(httpCodes.OK).send(result);
            })
            .catch((error: Error) => {
                console.log(error);
                res.status(httpCodes.NOT_FOUND).send(error);
            });
        });

        router.delete("/delete/movie/:id", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.id === -1) {
                res.send({
                    status: httpCodes.BAD_REQUEST
                });
            } else {
                this.databaseService.deleteFilm(req.params.id)
                .then((result: pg.QueryResult) => {
                    res.send({
                        status: httpCodes.OK
                    });
                }).catch((e: Error) => {
                    res.send({
                        status: httpCodes.INTERNAL_SERVER_ERROR
                    });
                    console.error(e.message);
                });
            }
        });

        router.get("/movie/:userId/:filmId", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.userId === -1 || req.params.filmId === -1) {
                res.sendStatus(httpCodes.BAD_REQUEST);
            } else {
                this.databaseService.getMemberWatchInformation(req.params.userId, req.params.filmId)
                .then((result: pg.QueryResult) => {
                    res.status(httpCodes.OK);
                    res.send(result.rows);
                }).catch((e: Error) => {
                    res.sendStatus(httpCodes.NOT_FOUND);
                    console.error(e.message);
                });
            }
        });

        router.delete("/delete/member/:id", (req: Request, res: Response, next: NextFunction) => {
            if (req.params.id === -1) {
                res.status(httpCodes.BAD_REQUEST).send(false);
            } else {
                this.databaseService.deleteMember(req.params.id)
                .then((result: pg.QueryResult) => {
                    res.status(httpCodes.OK).send();
                }).catch((e: Error) => {
                    res.status(httpCodes.INTERNAL_SERVER_ERROR).send(false);
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
                return true;
            }
        }

        return false;
    }

    private sanitizeFilm (film: Filme): boolean {
        const filmValidated: boolean = REGEXP_FILTER.test(film.titre);
        const genreValidated: boolean = REGEXP_FILTER.test(film.genre);
        const dateValidated: boolean = REGEXP_DATE_PATTERN.test(film.date_production);
        const lengthValidated: boolean = REGEXP_TIME_PATTERN.test(film.duree);

        return !filmValidated && !genreValidated && dateValidated && lengthValidated;
    }

    private sanitizeMember (member: Membre): boolean {
        const courrielValidated: boolean = REGEXP_EMAIL_PATTERN.test(member.courriel);
        const mdpValidated: boolean = REGEXP_PASSWD_PATTERN.test(member.motdepasse);
        const nomValidated: boolean = REGEXP_NAME_PATTERN.test(member.nom);
        const rueValidated: boolean = REGEXP_FILTER.test(member.rue);
        const villeValidated: boolean = REGEXP_CITY_PATTERN.test(member.ville);
        const codepostalValidated: boolean = REGEXP_POSTAL_CODE_PATTERN.test(member.codepostal);

        return courrielValidated && mdpValidated && nomValidated && !rueValidated && villeValidated && codepostalValidated;
    }

}
