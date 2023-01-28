import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
// tslint:disable-next-line:ordered-imports
import { concat, Observable, Subject } from "rxjs";
import { Filme } from "./../../../../common/tables/filme";
import { Membre } from "./../../../../common/tables/membre";
import { LoggingInUser } from "./../models/user";

@Injectable()
export class CommunicationService {

    public currentUser: Membre;

    private readonly BASE_URL: string = "http://localhost:3000/database";
    public constructor(private http: HttpClient) {
        this.currentUser = {
            id_membre: -1,
            courriel: "null",
            motdepasse: "null",
            nom: "null",
            rue: "null",
            ville: "null",
            codepostal: "null",
            estAdmin: false,
        };
    }

    private _listners: any = new Subject<any>();

    public listen(): Observable<any> {
       return this._listners.asObservable();
    }

    public setUpDatabase(): Observable<any> {
        return concat(this.http.post<any>(this.BASE_URL + "/createSchema", []),
                      this.http.post<any>(this.BASE_URL + "/populateDb", []));
    }

    public login(user: LoggingInUser): Observable<object> {
        return this.http.post(this.BASE_URL + "/login", user);
    }

    public isAdmin(): Observable<any> {
        return this.http.get(`${this.BASE_URL}/admin/${this.currentUser.id_membre}`);
    }

    public getMovies(): Observable<any> {
        return this.http.get(`${this.BASE_URL}/movies/all`);
    }

    public getMembers(): Observable<any> {
        return this.http.get(`${this.BASE_URL}/members/all`);
    }

    public getInfo(film: Filme): Observable<any> {
        return this.http.get(`${this.BASE_URL}/movies/${film.noFilme}`);
    }

    public deleteMember(member: Membre): Observable<any> {
        return this.http.delete(`${this.BASE_URL}/delete/member/${member.id_membre}`);
    }

    public deleteMovie(movie: Filme): Observable<any> {
        return this.http.delete(`${this.BASE_URL}/delete/movie/${movie.noFilme}`);
    }

    public addFilm(film: Filme): Observable<any> {
        return this.http.post(`${this.BASE_URL}/add/movie`, film);
    }

    public updateFilm(film: Filme): Observable<any> {
        return this.http.patch(`${this.BASE_URL}/update/movie`, film);
    }

    public addMember(member: Membre): Observable<any> {
        return this.http.post(`${this.BASE_URL}/add/member`, member);
    }

    public getFilmInfo(userId: number, filmId: number): Observable<any> {
        return this.http.get(`${this.BASE_URL}/movie/${userId}/${filmId}`);
    }
}
