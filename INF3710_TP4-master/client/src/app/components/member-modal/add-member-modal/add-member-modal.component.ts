import { Component, OnInit } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatDialog, MatSnackBar, MatSnackBarConfig } from "@angular/material";
import { REGEXP_CITY_PATTERN, REGEXP_EMAIL_PATTERN, REGEXP_NAME_PATTERN,
  REGEXP_PASSWD_PATTERN, REGEXP_POSTAL_CODE_PATTERN, REGEXP_STREET_PATTERN } from "../../../../../../common/utils/patterns";
import { CommunicationService } from "./../../../services/communication.service";

@Component({
  selector: "app-add-member-modal",
  templateUrl: "./add-member-modal.component.html",
  styleUrls: ["./add-member-modal.component.scss"]
})
export class AddMemberModalComponent implements OnInit {

  public loading: boolean;
  public courriel: FormControl;
  public motdepasse: FormControl;
  public nom: FormControl;
  public rue: FormControl;
  public ville: FormControl;
  public codepostal: FormControl;
  public isAdmin: boolean;

  public constructor(private matDialog: MatDialog, private snackBar: MatSnackBar, private commService: CommunicationService) { }

  public ngOnInit(): void {
    this.courriel = new FormControl("", [Validators.required, Validators.pattern(REGEXP_EMAIL_PATTERN)]);
    this.motdepasse = new FormControl("", [Validators.required, Validators.pattern(REGEXP_PASSWD_PATTERN)]);
    this.nom = new FormControl("", [Validators.required, Validators.pattern(REGEXP_NAME_PATTERN)]);
    this.rue = new FormControl("", [Validators.pattern(REGEXP_STREET_PATTERN)]);
    this.ville = new FormControl("", [Validators.pattern(REGEXP_CITY_PATTERN)]);
    this.codepostal = new FormControl("", [Validators.pattern(REGEXP_POSTAL_CODE_PATTERN)]);
    this.isAdmin = false;
  }

  public async addUser(): Promise<void> {
    this.loading = true;
    await this.commService.addMember({
      id_membre: -1,
      courriel: this.courriel.value,
      motdepasse: this.motdepasse.value,
      nom: this.nom.value,
      rue: this.rue.value,
      ville: this.ville.value,
      codepostal: this.codepostal.value,
      estAdmin: this.isAdmin,
    }).toPromise()
    .then((res: Response) => {
      const OK: number = 200;
      const CONFLICT: number = 409;
      if (res.status === OK) {
        this.openSnackBar("success");
        this.loading = false;
      } else if (res.status === CONFLICT) {
        this.openSnackBar("error-email-exists");
        this.loading = false;
      }
    })
    .catch((err: Error) => {
      console.log(err);
      this.openSnackBar("error");
      this.loading = false;
    });
  }
  public openSnackBar(option: string): void {
    const defaultDuration: number = 1000;
    const config: MatSnackBarConfig = new MatSnackBarConfig();
    config.duration = defaultDuration;
    config.horizontalPosition = "center";
    config.verticalPosition = "bottom";

    switch (option) {
      case "success": this.snackBar.open("Membre ajouté!", "OK", config); break;
      case "error": this.snackBar.open("Erreur lors de l'ajout du membre", "OK", config); break;
      case "error-email-exists": this.snackBar.open("Ce courriel est déjà associé à un compte de la base de donnée", "OK", config); break;
      default:
      break;
    }
  }

  public getPassErrorMessage(): string {
    if (this.motdepasse.hasError("required")) {
      return "Il ne serait pas très secure de laisser le mot de passe vide!";
    } else if (this.motdepasse.hasError("pattern")) {
      return "Doit contenir: 1 Majuscule (A-Z), 1 Minuscule (a-z), 1 Numéro (0-9) et être entre 6-32 caractères";
    }

    return "Le courriel est invalide";
  }

  public cancel(): void {
    this.matDialog.closeAll();
  }

  public valideEntry(): boolean {
    return this.nom.valid && this.courriel.valid && this.motdepasse.valid && this.rue.valid && this.codepostal.valid && this.ville.valid;
  }
}
