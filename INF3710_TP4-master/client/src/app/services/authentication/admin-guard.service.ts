import { Observable } from 'rxjs';
import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, CanActivate, RouterStateSnapshot} from "@angular/router";
import { CommunicationService } from "./../communication.service";

@Injectable({
  providedIn: "root"
})
export class AdminGuardService implements CanActivate {

  public constructor(private commService: CommunicationService) {/***/}
  public canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> {
    return this.commService.isAdmin();
  }

}
