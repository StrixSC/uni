import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, CanActivate, RouterStateSnapshot} from "@angular/router";
import { CommunicationService } from "./../communication.service";
import { StorageService } from "./../storage.service";

@Injectable({
  providedIn: "root"
})
export class UserGuardService implements CanActivate {

  public constructor(private comService: CommunicationService, private storage: StorageService) {/***/}

  public canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
    const userId: number = this.comService.currentUser.id_membre;

    return userId !== -1 && this.storage.userID === userId ? true : false;
  }
}
