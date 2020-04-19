import { Injectable } from "@angular/core";
import { Membre } from './../../../../common/tables/membre';

@Injectable()
export class StorageService {
    public constructor() {
        /** */
    }

    public saveUser(member: Membre): void {
        window.localStorage.setItem("current-user", `${member.id_membre}`);
    }
}
