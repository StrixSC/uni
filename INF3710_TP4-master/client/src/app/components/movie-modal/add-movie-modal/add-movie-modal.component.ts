import { Component, OnInit } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatDialog, MatSelectChange, MatSnackBar, MatSnackBarConfig } from "@angular/material";
import { REGEXP_DATE_PATTERN, REGEXP_TIME_PATTERN, REGEXP_TITLE_PATTERN } from "./../../../../../../common/models/patterns";
import { CommunicationService } from "./../../../services/communication.service";

@Component({
  selector: "app-add-movie-modal",
  templateUrl: "./add-movie-modal.component.html",
  styleUrls: ["./add-movie-modal.component.scss"]
})
export class AddMovieModalComponent implements OnInit {

  public loading: boolean;
  public titre: FormControl;
  public dateProduction: FormControl;
  public duree: FormControl;
  public genres: string[];
  public selectedGenre: string;

  public constructor(public commService: CommunicationService, private matDialog: MatDialog, private snackBar: MatSnackBar) {
    /***/
  }

  public ngOnInit(): void {
    this.loading = false;
    this.titre = new FormControl("", [Validators.required, Validators.pattern(REGEXP_TITLE_PATTERN)]);
    this.dateProduction = new FormControl("", [Validators.required, Validators.pattern(REGEXP_DATE_PATTERN)]);
    this.duree = new FormControl("", [Validators.required, Validators.pattern(REGEXP_TIME_PATTERN)]);
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

  public changeGenre(event: MatSelectChange): void {
    console.log(event.value);
    this.selectedGenre = event.value;
  }

  public async addFilm(): Promise<void> {
    this.loading = true;
    if (this.validEntry()) {
      await this.commService.addFilm({
        noFilme: -1,
        titre: this.titre.value,
        genre: this.selectedGenre,
        date_production: this.dateProduction.value,
        duree: this.duree.value
      }).toPromise()
      .then((res: Response) => {
        console.log(res);
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
        this.openSnackBar("error");
        this.loading = false;
        console.log(err);
      });
    }
  }

  public cancel(): void {
    this.matDialog.closeAll();
  }

  public validEntry(): boolean {
    return this.titre.valid && this.dateProduction.valid && this.duree.valid;
  }

  public openSnackBar(successOrError: string): void {
    const defaultDuration: number = 1000;
    const config: MatSnackBarConfig = new MatSnackBarConfig();
    config.duration = defaultDuration;
    config.horizontalPosition = "center";
    config.verticalPosition = "bottom";

    if (successOrError === "success") {
      this.snackBar.open("Film sauvegardé!", "OK", config);
    } else {
      this.snackBar.open("Erreur lors de la sauvegarde", "OK", config);
    }
  }
}
