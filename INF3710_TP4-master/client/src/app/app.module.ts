import { StorageService } from './services/storage.service';
import { CommonModule } from "@angular/common";
import { HttpClientModule } from "@angular/common/http";
import { NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MatButtonModule,
  MatCardModule, MatChipsModule, MatDialogModule, MatFormFieldModule, MatIconModule,
  MatInputModule, MatListModule, MatOptionModule,
  MatSelectModule, MatSidenavModule, MatSliderModule, MatToolbarModule, MatTooltipModule} from "@angular/material";
import { BrowserModule } from "@angular/platform-browser";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { AppRoutingModule } from "./app-routing.module";
import { AppComponent } from "./app.component";
import { AdminPageComponent } from "./components/admin-page/admin-page.component";
import { HomePageComponent } from "./components/home-page/home-page.component";
import { RegisterPageComponent } from "./components/register-page/register-page.component";
import { UserPageComponent } from "./components/user-page/user-page.component";
import { CommunicationService } from "./services/communication.service";

@NgModule({
  declarations: [
    AppComponent,
    HomePageComponent,
    AdminPageComponent,
    UserPageComponent,
    RegisterPageComponent,
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
    MatSelectModule
  ],
  providers: [CommunicationService, StorageService],
  bootstrap: [AppComponent],
})
export class AppModule { }
