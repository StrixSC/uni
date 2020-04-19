import { Component, OnInit } from "@angular/core";
import { MatSnackBar } from "@angular/material";
import { CommunicationService } from "./../../services/communication.service";
import { SelectedMovieService } from "./../../services/selected-movie.service";

@Component({
  selector: "app-movie-modal",
  templateUrl: "./movie-modal.component.html",
  styleUrls: ["./movie-modal.component.scss"]
})
export class MovieModalComponent implements OnInit {
  public deleting: boolean;
  public constructor(private snackBar: MatSnackBar, public selectedMovieService: SelectedMovieService,
                     private commService: CommunicationService) { }

  public ngOnInit(): void {
    this.deleting = false;
  }

  public async deleteMovie(): Promise<void> {
      this.deleting = true;
      await this.commService.deleteMovie(this.selectedMovieService.selectedFilm).toPromise();
      this.snackBar.open("Filme supprimé!", "OK", {
        verticalPosition: "bottom",
        horizontalPosition: "center",
        duration: 3000,
      });
      this.deleting = false;
  }
}
