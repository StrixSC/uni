import { Component, ElementRef, OnDestroy, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { CommunicationService } from "./../../services/communication.service";
import { StorageService } from "./../../services/storage.service";

@Component({
  selector: "app-film-page",
  templateUrl: "./film-page.component.html",
  styleUrls: ["./film-page.component.scss"]
})
export class FilmPageComponent implements OnInit, OnDestroy {
  public filmId: number;
  private sub: any;
  public currentMovieInfo: any[];
  public currentTimeInSeconds: number;

  @ViewChild("videoFrame", {static: true}) public video: ElementRef;
  public constructor(private route: ActivatedRoute,
                     private commService: CommunicationService, private storage: StorageService) { }

  public async ngOnInit(): Promise<void> {
    this.currentMovieInfo = [];
    this.filmId = 0;
    this.sub = this.route.params.subscribe((params) => {
      this.filmId = +params["id"];
    });

    await this.commService.getFilmInfo(this.storage.userID, this.filmId).toPromise()
    .then((res: any[]) => {
      this.currentMovieInfo = res;
      if (this.currentMovieInfo.length === 0) {
        this.currentTimeInSeconds = 0;
        this.video.nativeElement.src = "https://www.youtube.com/embed/3UmC6acEHk0";
      } else {
        const stringTime: string = this.currentMovieInfo[0].duree_visionnement;
        const arr: string[] = stringTime.split(":");
        const minuteToSeconds: number = 60;
        const two: number = 2;
        this.currentTimeInSeconds = (+arr[0]) * minuteToSeconds * minuteToSeconds + (+arr[1]) * minuteToSeconds + (+arr[two]);
        this.video.nativeElement.src = `https://www.youtube.com/embed/3UmC6acEHk0?start=${this.currentTimeInSeconds}`;
      }
    })
    .catch((err: Error) => {
      console.log(err);
    });
  }

  public ngOnDestroy(): void {
    this.sub.unsubscribe();
  }

}
