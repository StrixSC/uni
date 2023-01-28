import { Component, OnInit } from "@angular/core";
import { MatSnackBar } from "@angular/material";
import { CommunicationService } from "./../../services/communication.service";
import { SelectedMemberService } from "./../../services/selected-member.service";
import { StorageService } from "./../../services/storage.service";

@Component({
  selector: "app-member-modal",
  templateUrl: "./member-modal.component.html",
  styleUrls: ["./member-modal.component.scss"]
})
export class MemberModalComponent implements OnInit {

  public deleting: boolean;
  public constructor(public snackBar: MatSnackBar, private storage: StorageService,
                     public selectedMemberService: SelectedMemberService, private commService: CommunicationService) { }

  public ngOnInit(): void {
    this.deleting = false;
  }

  public async deleteMember(): Promise<void> {
    if (this.selectedMemberService.selectedMember.id_membre === this.storage.userID ||
        this.selectedMemberService.selectedMember.id_membre === this.commService.currentUser.id_membre) {
      this.snackBar.open("Vous ne pouvez pas supprimer vous-même!", "OK", {
        verticalPosition: "bottom",
        horizontalPosition: "center",
        duration: 3000,
      });
    } else {
      this.deleting = true;
      await this.commService.deleteMember(this.selectedMemberService.selectedMember).toPromise();
      this.snackBar.open("Membre supprimé!", "OK", {
        verticalPosition: "bottom",
        horizontalPosition: "center",
        duration: 3000,
      });
      this.deleting = false;
    }
  }

}
