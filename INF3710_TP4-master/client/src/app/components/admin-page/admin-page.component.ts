import { Component, OnInit } from "@angular/core";
import { MatDialog, MatDialogConfig } from "@angular/material";
import { Filme } from "./../../../../../common/tables/filme";
import { Membre } from "./../../../../../common/tables/membre";
import { CommunicationService } from "./../../services/communication.service";
import { SelectedMemberService } from "./../../services/selected-member.service";
import { SelectedMovieService } from "./../../services/selected-movie.service";
import { MemberModalComponent } from "./../member-modal/member-modal.component";
import { MovieModalComponent } from "./../movie-modal/movie-modal.component";

@Component({
  selector: "app-admin-page",
  templateUrl: "./admin-page.component.html",
  styleUrls: ["./admin-page.component.scss"]
})
export class AdminPageComponent implements OnInit {
  public selectedShowMovies: boolean;
  public selectedShowMembers: boolean;
  public movies: Filme[];
  public members: Membre[];
  public constructor(private matDialog: MatDialog, private commService: CommunicationService,
                     private selectedMemberService: SelectedMemberService, private selectedMovieService: SelectedMovieService) {}

  public ngOnInit(): void {
    this.selectedShowMovies = false;
    this.selectedShowMembers = false;
  }

  public async showMoviesList(): Promise<void> {
    this.selectedShowMovies = !this.selectedShowMovies;
    await this.getMovies();
  }

  public async getMovies(): Promise<void> {
    const result: Filme[] = await this.commService.getMovies().toPromise();
    this.movies = result;
  }

  public async showMembersList(): Promise<void> {
    this.selectedShowMembers = !this.selectedShowMembers;
    await this.getMembers();
  }

  public async getMembers(): Promise<void> {
    const result: Membre[] = await this.commService.getMembers().toPromise();
    this.members = result;
  }

  public showMember(member: Membre): void {
    const config: MatDialogConfig = new MatDialogConfig();
    config.width = "600px";
    config.height = "600px";
    config.id = "admin-member-dialog";
    this.selectedMemberService.selectMember(member);
    this.matDialog.open(MemberModalComponent, config).afterClosed().subscribe(async () => {
      this.matDialog.closeAll();
      await this.getMembers();
    });
  }

  public async showMovie(movie: Filme): Promise<void> {
    const config: MatDialogConfig = new MatDialogConfig();
    config.width = "600px";
    config.height = "600px";
    config.id = "admin-movie-dialog";
    this.selectedMovieService.selectMovie(movie);
    this.matDialog.open(MovieModalComponent, config).afterClosed().subscribe(async () => {
      this.matDialog.closeAll();
      await this.getMovies();
    });
  }
}
