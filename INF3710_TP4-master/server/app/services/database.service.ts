import { injectable } from "inversify";
import * as pg from "pg";
import "reflect-metadata";
import {schema} from "../createSchema";
import {data} from "../populateDB";
import { Filme } from './../../../common/tables/filme';
import { Membre } from './../../../common/tables/membre';

@injectable()
export class DatabaseService {

    // A MODIFIER POUR VOTRE BD
    public connectionConfig: pg.ConnectionConfig = {
        user: "tp4",
        database: "Netflix_Poly",
        password: "tp4",
        port: 5432,
        host: "127.0.0.1",
        keepAlive : true
    };

    private pool: pg.Pool = new pg.Pool(this.connectionConfig);

    public constructor() {
        this.pool.connect()
        .then(() => {
            console.log('Connected');
        })
        .catch((err: Error) => {
            console.log('Connection failure', err);
        });
    }

    public async createSchema(): Promise<pg.QueryResult> {
        return this.pool.query(schema);
    }

    public async populateDb(): Promise<pg.QueryResult> {
        return this.pool.query(data);
    }

    public async loginUser(email: string, password: string): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `SELECT * FROM Netflix_Poly.Membre MEM WHERE MEM.Courriel = '${email}';`;
        return this.pool.query(queryText);
    }

    public async checkIfAdmin(id: number): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `SELECT MEM.estAdmin FROM Netflix_Poly.Membre MEM WHERE MEM.id_membre = ${id};`;

        return this.pool.query(queryText);
    }

    public async getAllMovies(): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `SELECT * FROM Netflix_Poly.Filme;`;

        return this.pool.query(queryText);
    }

    public async getAllUsers(): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `SELECT * FROM Netflix_Poly.Membre;`;

        return this.pool.query(queryText);
    }

    public async deleteMovie(id: number): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `DELETE FROM Netflix_Poly.Filme F WHERE F.NoFilme = ${id};`;

        return this.pool.query(queryText);
    }

    public async deleteMember(id: number): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `DELETE FROM Netflix_Poly.Membre MEM WHERE MEM.ID_Membre = ${id};`;

        return this.pool.query(queryText);
    }

    public async addMovie(filme: Filme): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, '${filme.titre}', '${filme.genre}',
        '${filme.date_production}', '${filme.duree}');`;

        return this.pool.query(queryText);
    }

    public async addMember(membre: Membre): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, '${membre.courriel}', '${membre.motdepasse}',
        '${membre.nom}', '${membre.rue}', '${membre.ville}', '${membre.codepostal}', FALSE);`;

        return this.pool.query(queryText);
    }

    public async updateFilm(film: Filme): Promise<pg.QueryResult<pg.QueryResultRow>> {
        const queryText: string = `UPDATE Netflix_Poly.Filme F SET "titre" = '${film.titre}', "genre" = '${film.genre}',
        "date_production" = '${film.date_production}', "duree" = '${film.duree}' WHERE F.NoFilme = '${film.noFilme}';`;

        return this.pool.query(queryText);
    }

}
