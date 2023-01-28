import { Injectable } from "@angular/core";
import { Membre } from "./../../../../common/tables/membre";

@Injectable()
export class SelectedMemberService {

    public selectedMember: Membre;

    public constructor() {
        this.selectedMember = {
            id_membre: -1,
            courriel: "null",
            motdepasse: "null",
            nom: "null",
            rue: "null",
            ville: "null",
            codepostal: "null",
            estAdmin: false,
        };
    }

    public selectMember(member: Membre): void {
        this.selectedMember = member;
    }

}
