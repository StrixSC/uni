import { Injectable } from "@angular/core";
import { CanActivate } from "@angular/router";
import { CommunicationService } from "./../communication.service";

@Injectable({
  providedIn: "root"
})
export class AdminGuardService implements CanActivate {

  public constructor(private commService: CommunicationService) {/***/}
  public async canActivate(): Promise<boolean> {
    let resultObj: any = {
      result: false
    };
    try {
      resultObj = await this.commService.isAdmin().toPromise();
    } catch (err) {
      /***/
    }

    return resultObj.result ? true : false;
  }

}
