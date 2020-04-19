import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, CanActivate, RouterStateSnapshot} from "@angular/router";

@Injectable({
  providedIn: "root"
})
export class AdminGuardService implements CanActivate {

  public constructor() {/***/}
  public canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
    return false;
  }

}
