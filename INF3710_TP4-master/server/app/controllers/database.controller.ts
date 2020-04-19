import * as crypto from "crypto";
import { NextFunction, Request, Response, Router } from "express";
import { inject, injectable } from "inversify";
import * as pg from "pg";
import { REGEXP_EMAIL_PATTERN, REGEXP_PASSWD_PATTERN } from '../../../common/models/patterns';
import { Membre } from './../../../common/tables/membre';

import {Hotel} from "../../../common/tables/Hotel";
import {Room} from '../../../common/tables/Room';

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

        router.get("/hotel",
                   (req: Request, res: Response, next: NextFunction) => {
                    // Send the request to the service and send the response
                    this.databaseService.getHotels().then((result: pg.QueryResult) => {
                    const hotels: Hotel[] = result.rows.map((hot: any) => (
                        {
                        hotelno: hot.hotelno,
                        hotelname: hot.hotelname,
                        city: hot.city
                    }));
                    res.json(hotels);
                }).catch((e: Error) => {
                    console.error(e.stack);
                });
            });

        router.get("/hotel/hotelNo",
                   (req: Request, res: Response, next: NextFunction) => {
                      this.databaseService.getHotelNo().then((result: pg.QueryResult) => {
                        const hotelPKs: string[] = result.rows.map((row: any) => row.hotelno);
                        res.json(hotelPKs);
                      }).catch((e: Error) => {
                        console.error(e.stack);
                    });
                  });

        router.post("/hotel/insert",
                    (req: Request, res: Response, next: NextFunction) => {
                        const hotelNo: string = req.body.hotelNo;
                        const hotelName: string = req.body.hotelName;
                        const city: string = req.body.city;
                        this.databaseService.createHotel(hotelNo, hotelName, city).then((result: pg.QueryResult) => {
                        res.json(result.rowCount);
                    }).catch((e: Error) => {
                        console.error(e.stack);
                        res.json(-1);
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

        router.get("/rooms",
                   (req: Request, res: Response, next: NextFunction) => {

                    this.databaseService.getRoomFromHotelParams(req.query)
                    .then((result: pg.QueryResult) => {
                        const rooms: Room[] = result.rows.map((room: Room) => (
                            {
                            hotelno: room.hotelno,
                            roomno: room.roomno,
                            typeroom: room.typeroom,
                            price: parseFloat(room.price.toString())
                        }));
                        res.json(rooms);
                    }).catch((e: Error) => {
                        console.error(e.stack);
                    });
            });

        router.post("/rooms/insert",
                    (req: Request, res: Response, next: NextFunction) => {
                    const room: Room = {
                        hotelno: req.body.hotelno,
                        roomno: req.body.roomno,
                        typeroom: req.body.typeroom,
                        price: parseFloat(req.body.price)};
                    console.log(room);

                    this.databaseService.createRoom(room)
                    .then((result: pg.QueryResult) => {
                        res.json(result.rowCount);
                    })
                    .catch((e: Error) => {
                        console.error(e.stack);
                        res.json(-1);
                    });
        });

        router.get("/tables/:tableName",
                   (req: Request, res: Response, next: NextFunction) => {
                this.databaseService.getAllFromTable(req.params.tableName)
                    .then((result: pg.QueryResult) => {
                        res.json(result.rows);
                    }).catch((e: Error) => {
                        console.error(e.stack);
                    });
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
