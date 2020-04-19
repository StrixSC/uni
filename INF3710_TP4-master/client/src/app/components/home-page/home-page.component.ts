import { Component, OnInit } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { Router } from "@angular/router";
import { REGEXP_EMAIL_PATTERN } from "./../../../../../common/models/patterns";
import { Membre } from "./../../../../../common/tables/membre";
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

  public constructor(private comService: CommunicationService, private router: Router, private storageService: StorageService) { }

  public ngOnInit(): void {
    this.loading = false;
    this.email = new FormControl("", [Validators.required, Validators.pattern(REGEXP_EMAIL_PATTERN)]);
    this.password = new FormControl("", [Validators.required]);
  }

  public async initDatabase(): Promise<void> {
    this.loading = true;
    this.comService.setUpDatabase().subscribe(
    (res) => {
      this.loading = false;
      console.log(res);
    },
    (err) => {
      this.loading = false;
      console.log(err);
    });
  }

  public async login(): Promise<void> {
    this.loading = true;
    this.comService.login({
      email: this.email.value,
      password: this.password.value
    }).subscribe(async (res: Membre) => {
      this.comService.currentUser = res;
      this.loading = false;
      this.storageService.saveUser(this.comService.currentUser);
      await this.router.navigateByUrl("membre");
    },           () => {
      this.loading = false;
    });
  }

  public async register(): Promise<boolean> {
    return this.router.navigateByUrl("inscrire");
  }

}
