import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { AdminPageComponent } from "./components/admin-page/admin-page.component";
import { FilmPageComponent } from "./components/film-page/film-page.component";
import { HomePageComponent } from "./components/home-page/home-page.component";
import { RegisterPageComponent } from "./components/register-page/register-page.component";
import { UserPageComponent } from "./components/user-page/user-page.component";
import { AdminGuardService } from "./services/authentication/admin-guard.service";
import { UserGuardService } from "./services/authentication/user-guard.service";

const routes: Routes = [
  { path: "", component: HomePageComponent},
  { path: "administrateur", component: AdminPageComponent, canActivate: [AdminGuardService]},
  { path: "inscrire", component: RegisterPageComponent },
  { path: "membre", component: UserPageComponent, canActivate: [UserGuardService] },
  { path: "regarder/:id", component: FilmPageComponent, canActivate: [UserGuardService]},
  { path: "**", component: HomePageComponent},
];

@NgModule({
  imports: [
    RouterModule.forRoot(
      routes,
      {
        enableTracing: false,
      }
    )
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule { }
// tslint:disable-next-line: typedef
