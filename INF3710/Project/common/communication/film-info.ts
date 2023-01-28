import { FilmParticipant } from './../tables/film-participant';
import { Participant } from './../tables/participant';
import { Oscar } from './../tables/oscar';
import { NominationOscar } from './../tables/nomination-oscar';
import { Filme } from './../tables/filme';

export interface FilmInfo {
    film: Filme,
    nomination: NominationOscar;
    oscar: Oscar;
    participants: Participant;
    filmeParticipant: FilmParticipant;
}