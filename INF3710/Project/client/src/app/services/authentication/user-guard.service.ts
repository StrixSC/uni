import { Injectable } from "@angular/core";
import { CanActivate} from "@angular/router";
import { StorageService } from "./../storage.service";

@Injectable({
  providedIn: "root"
})
export class UserGuardService implements CanActivate {

  public constructor(private storage: StorageService) {/***/}

  public canActivate(): boolean {
    return this.storage.userID !== -1 && this.storage.userID !== null && this.storage.userID !== undefined ? true : false;
  }
}
