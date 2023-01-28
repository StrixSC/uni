import { Membre } from './membre';
export interface MembreMensuel extends Membre {
    prixAbonnement: number;
    dateDebut: string;
    dateFin?: string;
    echeance: string;
}