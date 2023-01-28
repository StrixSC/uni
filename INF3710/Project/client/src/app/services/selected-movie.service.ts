import { Injectable } from "@angular/core";
import { Filme } from "./../../../../common/tables/filme";

@Injectable()
export class SelectedMovieService {

    public selectedFilm: Filme;

    public constructor() {
        this.selectedFilm = {
            noFilme: -1,
            titre: "",
            date_production: "",
            duree: "",
            genre: ""
        };
    }

    public selectMovie(film: Filme): void {
        this.selectedFilm = film;
    }

}
