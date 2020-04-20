import { Component, OnInit } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { Router } from "@angular/router";
import { PASS_MAX_LENGTH, PASS_MIN_LENGTH, PASS_PATTERN } from "../../../../../common/utils/patterns";
import { REGEXP_EMAIL_PATTERN } from "../../../../../common/utils/patterns";
import { Membre } from "./../../../../../common/tables/membre";

@Component({
  selector: "app-register-page",
  templateUrl: "./register-page.component.html",
  styleUrls: ["./register-page.component.scss"]
})
export class RegisterPageComponent implements OnInit {
  public loading: boolean;
  public email: FormControl;
  public password: FormControl;
  public name: FormControl;
  public street: FormControl;
  public city: FormControl;
  public postalCode: FormControl;

  public constructor(public router: Router) {/***/ }

  public ngOnInit(): void {
    this.loading = false;
    this.email = new FormControl("", [Validators.required, Validators.pattern(REGEXP_EMAIL_PATTERN)]);
    this.password = new FormControl("", [Validators.required, Validators.minLength(PASS_MIN_LENGTH),
                                         Validators.maxLength(PASS_MAX_LENGTH), Validators.pattern(PASS_PATTERN)]);
    this.name = new FormControl("", [Validators.required]);
    this.street = new FormControl("");
    this.city = new FormControl("");
    this.postalCode = new FormControl("");
  }

  public register(): void {
    this.loading = true;
    const user: Membre = {
      id_membre: -1,
      courriel: this.email.value,
      motdepasse: this.password.value,
      nom: this.name.value,
      ville: this.city.value,
      codepostal: this.postalCode.value,
      rue: this.street.value,
      estAdmin: false,
    };
    console.log(user);
    this.loading = false;
    // this.comService.registerUser(user);
  }

  public invalidInfo(): boolean {
    return this.name.invalid || this.email.invalid || this.password.invalid;
  }

  public getPassErrorMessage(): string {
    if (this.password.hasError("required")) {
      return "Il ne serait pas très secure de laisser le mot de passe vide!";
    } else if (this.password.hasError("pattern")) {
      return "Doit contenir: 1 Majuscule (A-Z), 1 Minuscule (a-z), 1 Numéro (0-9) et être entre 6-32 caractères";
    }

    return "Le courriel est invalide";
  }

  public async login(): Promise<boolean> {
    return this.router.navigateByUrl("");
  }
}
