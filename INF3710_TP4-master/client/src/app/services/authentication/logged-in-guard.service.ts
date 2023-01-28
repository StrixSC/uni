import { Injectable } from "@angular/core";
import { CanActivate } from "@angular/router";
import { StorageService } from "./../storage.service";

@Injectable({
  providedIn: "root"
})
export class LoggedInGuard implements CanActivate {

  public constructor(private storage: StorageService) {/***/}

  public canActivate(): boolean {
        return this.storage.loggedIn;
    }
}
