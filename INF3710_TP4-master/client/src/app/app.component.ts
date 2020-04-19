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
    public constructor(private router: Router, private communicationService: CommunicationService, private storage: StorageService) {
    }

    public ngOnInit(): void {
        if (this.storage.loggedIn) {
            this.communicationService.currentUser = this.storage.getUser();
        }
    }

    public async deconnect(): Promise<void> {
        await this.router.navigateByUrl("");
        this.storage.clearAll();
        this.communicationService.currentUser = this.storage.getUser();
    }
}
