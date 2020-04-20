import { Injectable } from "@angular/core";
import { Membre } from "./../../../../common/tables/membre";

@Injectable()
export class StorageService {
    public constructor() {
        /** */
    }

    public saveUser(member: Membre): void {
        if (typeof Storage !== undefined) {
            window.localStorage.setItem("id", `${member.id_membre}`);
            window.localStorage.setItem("email", `${member.courriel}`);
            window.localStorage.setItem("name", `${member.nom}`);
            window.localStorage.setItem("city", `${member.ville}`);
            window.localStorage.setItem("postalcode", `${member.codepostal}`);
            window.localStorage.setItem("street", `${member.rue}`);
            window.localStorage.setItem("loggedIn", "true");
        }
    }

    public get userID(): number {
        const user: string | null = window.localStorage.getItem("id");
        if (user !== null) {
            const radix: number = 10;

            return parseInt(user, radix);
        } else {
            return -1;
        }
    }

    public getUser(): Membre {
        const id: string | null = window.localStorage.getItem("id");
        const email: string | null = window.localStorage.getItem("email");
        const name: string | null = window.localStorage.getItem("name");
        const city: string | null = window.localStorage.getItem("city");
        const postalcode: string | null = window.localStorage.getItem("postalcode");
        const street: string | null = window.localStorage.getItem("street");

        return {
            id_membre: id !== null ? parseInt(id, 10) : -1,
            courriel: email !== null ? email : "",
            ville: city !== null ? city : "",
            nom: name !== null ? name : "",
            codepostal: postalcode !== null ? postalcode : "",
            rue: street !== null ? street : "",
            motdepasse: "",
            estAdmin: false
        };
    }

    public clearAll(): void {
        window.localStorage.clear();
    }

    public get loggedIn(): boolean {
        return window.localStorage.length !== 0 && window.localStorage.getItem("id") !== "-1"  &&
        window.localStorage.getItem("loggedIn") === "true" ? true : false;
    }
}
