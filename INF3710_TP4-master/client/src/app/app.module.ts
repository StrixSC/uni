import { CommonModule, DatePipe } from "@angular/common";
import { HttpClientModule } from "@angular/common/http";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MatButtonModule,
  MatCardModule, MatCheckboxModule, MatChipsModule, MatDialogModule, MatFormFieldModule,
  MatIconModule, MatInputModule, MatListModule,
  MatOptionModule, MatSelectModule, MatSidenavModule, MatSliderModule, MatToolbarModule, MatTooltipModule} from "@angular/material";
import { MatSnackBarModule } from "@angular/material/snack-bar";
import { BrowserModule } from "@angular/platform-browser";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { MatVideoModule } from "mat-video";
import { AppRoutingModule } from "./app-routing.module";
import { AppComponent } from "./app.component";
import { AdminPageComponent } from "./components/admin-page/admin-page.component";
import { FilmPageComponent } from "./components/film-page/film-page.component";
import { HomePageComponent } from "./components/home-page/home-page.component";
import { AddMemberModalComponent } from "./components/member-modal/add-member-modal/add-member-modal.component";
import { MemberModalComponent } from "./components/member-modal/member-modal.component";
import { AddMovieModalComponent } from "./components/movie-modal/add-movie-modal/add-movie-modal.component";
import { MovieModalComponent } from "./components/movie-modal/movie-modal.component";
import { RegisterPageComponent } from "./components/register-page/register-page.component";
import { UserPageComponent } from "./components/user-page/user-page.component";
import { CommunicationService } from "./services/communication.service";
import { SelectedMemberService } from "./services/selected-member.service";
import { SelectedMovieService } from "./services/selected-movie.service";
import { StorageService } from "./services/storage.service";

@NgModule({
  declarations: [
    AppComponent,
    HomePageComponent,
    AdminPageComponent,
    UserPageComponent,
    RegisterPageComponent,
    MemberModalComponent,
    MovieModalComponent,
    AddMovieModalComponent,
    AddMemberModalComponent,
    FilmPageComponent,
  ],
  imports: [
    MatOptionModule,
    CommonModule,
    BrowserModule,
    MatTooltipModule,
    HttpClientModule,
    FormsModule,
    AppRoutingModule,
    MatFormFieldModule,
    MatToolbarModule,
    BrowserAnimationsModule,
    MatSliderModule,
    MatButtonModule,
    MatCardModule,
    MatInputModule,
    MatSidenavModule,
    MatChipsModule,
    MatDialogModule,
    MatListModule,
    MatIconModule,
    ReactiveFormsModule,
    MatSnackBarModule,
    MatSelectModule,
    MatVideoModule,
    MatCheckboxModule,
  ],
  entryComponents: [MemberModalComponent, MovieModalComponent],
  providers: [CommunicationService, StorageService, SelectedMovieService, SelectedMemberService, DatePipe],
  bootstrap: [AppComponent],
})
export class AppModule { }
