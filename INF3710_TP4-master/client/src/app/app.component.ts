import { Component, OnInit } from "@angular/core";
import { Router } from "@angular/router";
import { CommunicationService } from "./services/communication.service";
import { StorageService } from "./services/storage.service";

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.scss"],
})
export class AppComponent implements OnInit {
    public route: string;
    public constructor(private router: Router, private communicationService: CommunicationService, private storage: StorageService) {
    }

    public async ngOnInit(): Promise<void> {
        if (this.storage.loggedIn) {
            this.communicationService.currentUser = this.storage.getUser();
            if (this.communicationService.isAdmin()) {
                await this.router.navigateByUrl("administrateur");
                this.route = this.router.url;
            } else {
                await this.router.navigateByUrl("membre");
                this.route = this.router.url;
            }

        } else {
            await this.router.navigateByUrl("");
        }
    }

    public async deconnect(): Promise<void> {
        this.storage.clearAll();
        await this.router.navigateByUrl("");
        this.communicationService.currentUser = this.storage.getUser();
    }
}
