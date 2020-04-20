import { Component, OnInit } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatSnackBar } from "@angular/material";
import { Router } from "@angular/router";
import { REGEXP_EMAIL_PATTERN } from "../../../../../common/utils/patterns";
import { Membre } from "./../../../../../common/tables/membre";
import { AdminGuardService } from './../../services/authentication/admin-guard.service';
import { CommunicationService } from "./../../services/communication.service";
import { StorageService } from "./../../services/storage.service";

@Component({
  selector: "app-home-page",
  templateUrl: "./home-page.component.html",
  styleUrls: ["./home-page.component.scss"]
})
export class HomePageComponent implements OnInit {

  public loading: boolean;
  public email: FormControl;
  public password: FormControl;

  public constructor(private comService: CommunicationService, private adminGuard: AdminGuardService, private snackBar: MatSnackBar,
                     private router: Router, private storageService: StorageService) { }

  public async ngOnInit(): Promise<void> {
    this.loading = false;
    this.email = new FormControl("", [Validators.required, Validators.pattern(REGEXP_EMAIL_PATTERN)]);
    this.password = new FormControl("", [Validators.required]);
    if (this.storageService.loggedIn) {
      await this.router.navigateByUrl("membre");
    }
  }

  public async initDatabase(): Promise<void> {
    this.loading = true;
    this.comService.setUpDatabase().subscribe(
    () => {
      this.loading = false;
    },
    () => {
      this.loading = false;
    });
  }

  public async login(): Promise<void> {
    this.loading = true;
    this.storageService.clearAll();
    this.comService.login({
      email: this.email.value,
      password: this.password.value
    }).toPromise().then(async (res: Membre) => {
      this.comService.currentUser = res;
      this.storageService.saveUser(this.comService.currentUser);
      const result: boolean = await this.adminGuard.canActivate();
      console.log(result);
      if (result) {
        await this.router.navigateByUrl("administrateur");
      } else {
        await this.router.navigateByUrl("membre");
      }})
      .catch((err) => {
      this.snackBar.open("Le courriel/Mot de passe est invalide.", "OK", {
        verticalPosition: "bottom",
        horizontalPosition: "center",
        duration: 500
      });
      this.loading = false;
    });
  }

  public async register(): Promise<boolean> {
    return this.router.navigateByUrl("inscrire");
  }

}
