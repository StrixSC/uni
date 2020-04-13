-- Database: Netflix_Poly

SET search_path = Netflix_Poly;
DROP SCHEMA IF EXISTS Netflix_Poly CASCADE;
CREATE SCHEMA Netflix_Poly;

CREATE DOMAIN Netflix_Poly.sexeType AS VARCHAR(32)
    CHECK (VALUE IN ('Homme', 'Femme', 'Autre'));

CREATE DOMAIN Netflix_Poly.role AS VARCHAR(255)
    CHECK (VALUE IN ('Réalisateur', 'Producteur', 'Caméraman', 'Écrivain(e)', 'Cinématographeur(euse)',
    'Génie Sonore', 'Effets visuels','Acteur(e)', 'Maquilleur(euse)', 'Metteur en scène'));

CREATE DOMAIN Netflix_Poly.genre AS VARCHAR(255)
    CHECK (VALUE IN ('Drame', 'Romance', 'Comédie', 'Action', 'Historique', 'Documentaire', 'Animation',
    'Western', 'Musicale', 'Fantasy', 'Thriller', 'Horreur', 'Catastrophe', 'Policier', 'Science-fiction', 'Aventure'));

CREATE DOMAIN Netflix_Poly.oscar_catégorie AS VARCHAR(255)
	CHECK (VALUE IN ('Meilleur Réalisateur', 'Meilleur Acteur', 'Meilleur Acteur dans un second rôle', 'Meilleure Actrice',
	'Meilleure Actrice dans un second rôle', 'Meilleure Chanson Originale', 'Meilleure Choréographie', 'Meilleure Costumes',
	'Meilleur Court métrage', 'Meilleur effets visuels', 'Meilleur Producteur', 'Meilleur Maquilleur', 'Meilleur Metteur en scène'));

CREATE TABLE IF NOT EXISTS  Netflix_Poly.Membre (
    ID_Membre	SERIAL			NOT NULL,
    Courriel 	VARCHAR(255)	UNIQUE NOT NULL,
    MotDePasse 	VARCHAR(255) 	NOT NULL,
    Nom 		VARCHAR(255) 	NOT NULL,
    Rue			VARCHAR(255),
    Ville		VARCHAR(255),
    CodePostal	VARCHAR(255),
    estAdmin    BOOLEAN         NOT NULL,
	PRIMARY KEY (ID_Membre)
);

CREATE TABLE IF NOT EXISTS  Netflix_Poly.MembreMensuel (
    ID_Membre INT NOT NULL,
	PrixAbonnement DECIMAL(12,2)	NOT NULL,
	DateDebut	DATE	    NOT NULL,
	DateFin		DATE,
	Echeance	DATE	    NOT NULL,
    PRIMARY KEY (ID_Membre),
	FOREIGN KEY (ID_Membre) REFERENCES Netflix_Poly.Membre(ID_Membre)
);

CREATE TABLE IF NOT EXISTS  Netflix_Poly.MembrePPV (
	ID_Membre INT NOT NULL,
	film_payperview INT NOT NULL,
    PRIMARY KEY(ID_Membre),
	FOREIGN KEY (ID_Membre) REFERENCES Netflix_Poly.Membre(ID_Membre)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.CarteCredit (
    NoCarte     VARCHAR(255) NOT NULL,
    ID_Membre   INT NOT NULL,
    Titulaire   VARCHAR(255) NOT NULL,
    Date_Exp    DATE NOT NULL,
    CCV         VARCHAR(3) NOT NULL,
    PRIMARY KEY (NoCarte),
    FOREIGN KEY (ID_Membre) REFERENCES Netflix_Poly.Membre(ID_Membre)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.Commande (
    NoCommande  SERIAL NOT NULL,
    ID_Membre INT NOT NULL,
    NoDvd INT NOT NULL,
    Date_Envoi DATE NOT NULL,
    Distance DECIMAL(12,2) NOT NULL,
    Cout DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (NoCommande),
    FOREIGN KEY (ID_Membre) REFERENCES Netflix_Poly.Membre(ID_Membre)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.Filme (
    NoFilme SERIAL NOT NULL,
    Titre VARCHAR(255) NOT NULL,
    Genre Netflix_Poly.genre DEFAULT('Action'),
    Date_Production DATE,
    Duree TIME NOT NULL,
    PRIMARY KEY(NoFilme)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.Participant (
    NAS VARCHAR(9) NOT NULL,
    Nom VARCHAR(255),
    Age INT,
    Sexe Netflix_Poly.sexeType DEFAULT ('Homme'),
    Nationalite VARCHAR(255),
    PRIMARY KEY (NAS)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.DVD (
    ID_Dvd SERIAL NOT NULL,
    NoFilme INT NOT NULL,
    PRIMARY KEY (ID_Dvd),
    FOREIGN KEY (NoFilme) REFERENCES Netflix_Poly.Filme(NoFilme)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.FilmeParticipant (
    NAS  VARCHAR(9) NOT NULL,
    NoFilme INT NOT NULL,
    Role Netflix_Poly.role DEFAULT ('Acteur'),
    Salaire DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (NAS, NoFilme),
    FOREIGN KEY (NAS) REFERENCES Netflix_Poly.Participant(NAS),
    FOREIGN KEY (NoFilme) REFERENCES Netflix_Poly.Filme(NoFilme)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.Oscar (
    ID_Oscar SERIAL NOT NULL,
    Date_Ceremonie DATE NOT NULL,
    Lieu VARCHAR(255) NOT NULL,
    Maitre_Ceremonie VARCHAR(255),
    PRIMARY KEY (ID_Oscar)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.Nomination_Oscar (
    NoFilme INT NOT NULL,
    ID_Oscar SERIAL NOT NULL,
    Nomination Netflix_Poly.oscar_catégorie DEFAULT ('Meilleur Acteur'),
    Gagnant BOOLEAN NOT NULL,

    PRIMARY KEY (NoFilme, ID_Oscar),
    FOREIGN KEY (NoFilme) REFERENCES Netflix_Poly.Filme(NoFilme),
    FOREIGN KEY (ID_Oscar) REFERENCES Netflix_Poly.Oscar(ID_Oscar)
);

CREATE TABLE IF NOT EXISTS Netflix_Poly.Visionnement (
    ID_Membre INT NOT NULL,
    NoFilme INT NOT NULL,
    Date_Visionnement DATE NOT NULL,
    Duree_Visionnement TIME NOT NULL,
    FOREIGN KEY (ID_Membre) REFERENCES Netflix_Poly.Membre(ID_Membre)
);

