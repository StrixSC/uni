import { Component, OnInit } from "@angular/core";
import { MatSnackBar, MatSnackBarConfig } from "@angular/material";
import { Router } from "@angular/router";
import { FilmParticipant } from "./../../../../../common/tables/film-participant";
import { Filme } from "./../../../../../common/tables/filme";
import { NominationOscar } from "./../../../../../common/tables/nomination-oscar";
import { Oscar } from "./../../../../../common/tables/oscar";
import { Participant } from "./../../../../../common/tables/participant";
import { CommunicationService } from "./../../services/communication.service";
import { SelectedMovieService } from "./../../services/selected-movie.service";

@Component({
  selector: "app-user-page",
  templateUrl: "./user-page.component.html",
  styleUrls: ["./user-page.component.scss"]
})
export class UserPageComponent implements OnInit {

  public films: Filme[];
  public currentFilmOscars: Oscar[];
  public currentFilmNoms: NominationOscar[];
  public currentFilmParticipants: Participant[];
  public currentFilmCrew: FilmParticipant[];
  public currentFilm: Filme;
  public showOscars: boolean;
  public showCrew: boolean;

  public constructor(private router: Router, private snackBar: MatSnackBar, private commService: CommunicationService,
                     private selectedMovieService: SelectedMovieService) {/** */}

  public async ngOnInit(): Promise<void> {
    this.showOscars = false;
    this.showCrew = false;
    this.currentFilm = {
      titre: "",
      date_production: "",
      noFilme: -1,
      duree: "",
      genre: "",
    };
    this.films = [];
    this.currentFilmCrew = [];
    this.currentFilmNoms = [];
    this.currentFilmOscars = [];
    this.currentFilmParticipants = [];
    await this.commService.getMovies().toPromise()
    .then((res: Filme[]) => {
      this.films = res;
      this.currentFilm = this.films[0];
    })
    .catch((err: Error) => {
      this.openSnackBar("film-load-error");
      console.log(err);
    });
  }

  public async getInfo(film: Filme): Promise<void> {
    this.currentFilm = film;
    const result: any = await this.commService.getInfo(film).toPromise();
    this.extractInfo(result, film);
  }

  // tslint:disable-next-line: max-func-body-length
  public extractInfo(arr: any[], film: Filme): void {
    console.log(arr);
    const oscars: Oscar[] = [];
    const nominations: NominationOscar[] = [];
    const fParticipants: FilmParticipant[] = [];
    const participants: Participant[] = [];

    // tslint:disable-next-line: prefer-for-of
    for (let i: number = 0; i < arr[0].length; i++) {
      if (arr[0][i] !== undefined) {
        const oscar: Oscar = {
          idOscar: arr[0][i].id_oscar,
          dateCeremonie: arr[0][i].date_ceremonie,
          lieu: arr[0][i].lieu,
          maitreCeremonie: arr[0][i].maitre_ceremonie
        };
        oscars.push(oscar);
        const nomination: NominationOscar = {
          noFilme: film.noFilme,
          idOscar: arr[0][i].id_oscar,
          gagnant: arr[0][i].gagnant,
          nomination: arr[0][i].nomination,
        };
        nominations.push(nomination);
      }
    }

    // tslint:disable-next-line: prefer-for-of
    for (let i: number = 0; i < arr[1].length; i++) {
    if (arr[1][i] !== undefined) {
        const participant: Participant = {
          nas: arr[1][i].nas,
          age: arr[1][i].age,
          nom: arr[1][i].nom,
          sexe: arr[1][i].sexe,
          nationalite: arr[1][i].nationalite
        };
        participants.push(participant);
        const filmPart: FilmParticipant = {
          nas: arr[1][i].nas,
          noFilme: film.noFilme,
          role: arr[1][i].role,
          salaire: arr[1][i].salaire
        };
        fParticipants.push(filmPart);
      }
    }

    this.currentFilmOscars = oscars;
    this.currentFilmCrew = fParticipants;
    this.currentFilmParticipants = participants;
    this.currentFilmNoms = nominations;

    console.log(this.currentFilmOscars);
    console.log(this.currentFilmCrew);
    console.log(this.currentFilmParticipants);
    console.log(this.currentFilmNoms);

  }

  public async goToFilm(): Promise<void> {
    this.selectedMovieService.selectMovie(this.currentFilm);
    await this.router.navigateByUrl(`regarder/${this.currentFilm.noFilme}`);
  }

  public openSnackBar(option: string): void {
    const defaultDuration: number = 1000;
    const config: MatSnackBarConfig = new MatSnackBarConfig();
    config.duration = defaultDuration;
    config.horizontalPosition = "center";
    config.verticalPosition = "bottom";

    switch (option) {
      case "film-load-error": this.snackBar.open("Erreur lors du chargement des filmes", "OK", config); break;
      default:
      break;
    }
  }
}
