import { DatePipe } from "@angular/common";
import { Component, OnInit } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatDialog, MatSnackBar, MatSnackBarConfig } from "@angular/material";
import { REGEXP_DATE_PATTERN, REGEXP_TIME_PATTERN, REGEXP_TITLE_PATTERN } from "../../../../../common/utils/patterns";
import { CommunicationService } from "./../../services/communication.service";
import { SelectedMovieService } from "./../../services/selected-movie.service";

@Component({
  selector: "app-movie-modal",
  templateUrl: "./movie-modal.component.html",
  styleUrls: ["./movie-modal.component.scss"]
})
export class MovieModalComponent implements OnInit {
  public deleting: boolean;
  public loading: boolean;
  public titre: FormControl;
  public dateProduction: FormControl;
  public duree: FormControl;
  public genres: string[];
  public selectedGenre: string;

  public constructor(private datePipe: DatePipe, private snackBar: MatSnackBar, public selectedMovieService: SelectedMovieService,
                     private commService: CommunicationService, private matDialog: MatDialog) { }

  public ngOnInit(): void {
    this.deleting = false;
    this.loading = false;
    this.titre = new FormControl(`${this.selectedMovieService.selectedFilm.titre}`,
                                 [Validators.required, Validators.pattern(REGEXP_TITLE_PATTERN)]);
    this.dateProduction = new FormControl(this.datePipe.transform(`${this.selectedMovieService.selectedFilm.date_production}`,
                                                                  "yyyy-LL-dd"),
                                          [Validators.required, Validators.pattern(REGEXP_DATE_PATTERN)]);
    this.duree = new FormControl(`${this.selectedMovieService.selectedFilm.duree}`,
                                 [Validators.required, Validators.pattern(REGEXP_TIME_PATTERN)]);
    this.genres = [
      "Drame",
      "Romance",
      "Comédie",
      "Action",
      "Historique",
      "Documentaire",
      "Animation",
      "Western",
      "Musicale",
      "Fantasy",
      "Thriller",
      "Horreur",
      "Catastrophe",
      "Policier",
      "Science-fiction",
      "Aventure",
    ];
    this.selectedGenre = this.genres[0];
  }

  public async deleteMovie(): Promise<void> {
      this.deleting = true;
      await this.commService.deleteMovie(this.selectedMovieService.selectedFilm).toPromise()
      .then((res) => {
        const OK: number = 200;
        if (res.status === OK) {
          this.openSnackBar("delete-success");
          this.deleting = false;
        } else {
          this.openSnackBar("delete-error");
          this.deleting = false;
        }
      })
      .catch((err) => {
        console.log(err);
        this.openSnackBar("delete-error");
        this.deleting = false;
      });
  }

  public cancel(): void {
    this.matDialog.closeAll();
  }

  public validEntry(): boolean {
    return this.titre.valid && this.dateProduction.valid && this.duree.valid;
  }

  public async patchFilm(): Promise<void> {
    this.loading = true;
    if (this.validEntry()) {
      await this.commService.updateFilm({
        noFilme: this.selectedMovieService.selectedFilm.noFilme,
        genre: this.selectedGenre,
        duree: this.duree.value,
        titre: this.titre.value,
        date_production: this.dateProduction.value
      }).toPromise()
      .then((res: Response) => {
        const OK: number = 200;
        if (res.status === OK) {
          this.openSnackBar("success");
          this.loading = false;
        } else {
          this.openSnackBar("error");
          this.loading = false;
        }
      })
      .catch((err) => {
        console.log(err);
        this.openSnackBar("error");
        this.loading = false;
      });
    }
  }

  public openSnackBar(option: string): void {
    const defaultDuration: number = 1000;
    const config: MatSnackBarConfig = new MatSnackBarConfig();
    config.duration = defaultDuration;
    config.horizontalPosition = "center";
    config.verticalPosition = "bottom";

    switch (option) {
      case "success": this.snackBar.open("Film modifié!", "OK", config); break;
      case "error": this.snackBar.open("Erreur lors de la modification", "OK", config); break;
      case "delete-error": this.snackBar.open("Erreur lors de la suppression", "OK", config); break;
      case "delete-success": this.snackBar.open("Filme supprimé!", "OK", config); break;
      default:
      break;
    }
  }
}
