
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'MavisePlaisance@teleworm.us', encode(sha256('rexouw3No'::bytea), 'hex'),
'Mavise Plaisance', '4495 Hyde Park Road', 'London', 'N6E 1A9', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'OlivierAllard@armyspy.com', encode(sha256('ietaixeeZ5'::bytea), 'hex'), 'Olivier Allard',
'430 Island Hwy', 'Campbell River', 'V9W 2C9', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'PorterLussier@teleworm.us', encode(sha256('Yu7shohmei'::bytea), 'hex'), 'Porter Lussier',
'2593 Fallon Drive', 'Dungannon', 'N0M 1R0', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'AyaSaindon@rhyta.com', encode(sha256('eYu2oog8'::bytea), 'hex'), 'Aya Saindon',
'3387 Nelson Street', 'Bala', 'P0C 1A0', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'ReneProvencher@gmail.com', encode(sha256('uax1AheeChae'::bytea), 'hex'),
'René Provencher', '1296 Boulevard Cremazie', 'Quebec', 'G1R 1B8', FALSE);
INSERT INTO Netflix_Poly.Membre VALUES (DEFAULT, 'DonatRaymond@jourrapide.com', encode(sha256('nae7Lip8ie'::bytea), 'hex'),
'Donat Raymond', '3701 Papineau Avenue', 'Montreal', 'H2K 4J5', FALSE);

INSERT INTO Netflix_Poly.MembreMensuel VALUES (1, 15.99, '2019-11-29', NULL,'2020-04-29');
INSERT INTO Netflix_Poly.MembreMensuel VALUES (5, 10.99, '2018-04-13', '2020-05-13', '2020-05-13');
INSERT INTO Netflix_Poly.MembreMensuel VALUES (3, 12.99, '2020-02-01', NULL,'2020-05-01');

INSERT INTO Netflix_Poly.MembrePPV VALUES (2, 43);
INSERT INTO Netflix_Poly.MembrePPV VALUES (4, 152);
INSERT INTO Netflix_Poly.MembrePPV VALUES (6, 02);

INSERT INTO Netflix_Poly.CarteCredit VALUES ('5599 1741 7806 6840', 1, 'MAVISE PLAISANCE', '2023-02-01', '632');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4929 6391 3985 7325', 1, 'MAVISE PLAISANCE', '2023-05-01', '215');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4556 7004 6742 2635', 2, 'OLIVIER ALLARD', '2024-12-01', '349');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4716 7615 5192 3646', 3, 'PORTER LUSSIER', '2026-03-01', '432');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('5442 9664 3497 9016', 3, 'PORTER LUSSIER', '2022-02-01', '939');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4532 1472 6838 1272', 4, 'AYA SAINDON', '2023-06-01', '957');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4929 4514 5832 2661', 4, 'AYA SAINDON', '2024-08-01', '584');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4485 0173 7898 1005', 4, 'AYA SAINDON', '2020-01-01', '382');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4929 0805 5097 9506', 5, 'RENÉ PROVENCHER', '2022-03-01', '102');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('4532 8576 3623 2540', 6, 'DONAT RAYMOND', '2021-08-01', '618');
INSERT INTO Netflix_Poly.CarteCredit VALUES ('5221 7619 0765 9246', 6, 'DONAT RAYMOND', '2022-07-01', '990');

INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 2, 1, '2020-04-29', 11.40, 11.40 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 2, 2, '2020-04-13', 11.40, 11.40 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 1, 1, '2020-05-01', 28.00, 28.00 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 1, 1, '2020-04-23', 28.00, 28.00 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 4, 3, '2020-04-30', 8.60, 8.60 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 6, 2, '2020-04-29', 2.10, 2.10 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 3, 5, '2020-05-02', 45.90, 45.90 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 2, 4, '2020-04-10', 11.40,  11.40 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 5, 3, '2020-03-29', 32.40, 32.40 * 0.25);
INSERT INTO Netflix_Poly.Commande VALUES (DEFAULT, 1, 6, '2020-03-27', 28.00, 28.00 * 0.25);

INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Bohemian Rhapsody', 'Drame', '2018-10-24', '02:13');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Avengers: Endgame', 'Action', '2019-04-26', '03:02');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Avengers: Infinity War', 'Action', '2017-04-27', '02:40');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Titanic', 'Drame', '1997-11-18', '03:15');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Jojo Rabbit', 'Comédie', '2020-02-04', '01:48');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Deadpool', 'Action', '2016-02-12', '01:49');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Cold Blood', 'Thriller', '2019-07-05', '01:31');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'The Purge', 'Thriller', '2013-06-07', '01:25');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'IT Chapter Two', 'Horreur', '2019-08-26', '02:50');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'The Lion King', 'Animation', '2019-07-9', '01:58');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'The Martian', 'Science-fiction', '2019-09-24', '02:31');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Ford v Ferrari', 'Action', '2019-08-30', '02:32');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, '1917', 'Historique', '2020-01-10', '01:59');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Big Hero 6', 'Animation', '2014-11-07', '01:48');
INSERT INTO Netflix_Poly.Filme VALUES (DEFAULT, 'Doctor Strange', 'Science-fiction', '2016-10-13', '01:55');

INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 1);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 2);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 4);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 3);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 2);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 6);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 7);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 4);
INSERT INTO Netflix_Poly.DVD VALUES (DEFAULT, 5);

INSERT INTO Netflix_Poly.Participant VALUES ('219638939', 'Oscar Jones', 39, 'Homme', 'Canada');
INSERT INTO Netflix_Poly.Participant VALUES ('761059237', 'Luke Cunningham', 21,'Homme', 'Angleterre');
INSERT INTO Netflix_Poly.Participant VALUES ('584026975', 'Chelsea Cole', 32 , 'Femme', 'Canada');
INSERT INTO Netflix_Poly.Participant VALUES ('192630275', 'Luke Miller', 26, 'Homme', 'États-Unis');
INSERT INTO Netflix_Poly.Participant VALUES ('928396142', 'Clark Foster', 43, 'Homme', 'Australie');
INSERT INTO Netflix_Poly.Participant VALUES ('520631649', 'Adelaide Russel', 54, 'Homme', 'Hollande');
INSERT INTO Netflix_Poly.Participant VALUES ('262816119', 'Sarah Phillips', 32, 'Femme', 'États-Unis');
INSERT INTO Netflix_Poly.Participant VALUES ('638012476', 'Caroline Dixon', 21, 'Femme', 'États-Unis');
INSERT INTO Netflix_Poly.Participant VALUES ('668985112', 'Sofia Smith', 32, 'Femme', 'Algérie');
INSERT INTO Netflix_Poly.Participant VALUES ('143464956', 'Aida Douglas', 26, 'Femme', 'Russie');
INSERT INTO Netflix_Poly.Participant VALUES ('396012676', 'Edward Ross', 42, 'Homme', 'Canada');
INSERT INTO Netflix_Poly.Participant VALUES ('961854650', 'Nicholas Taylor', 43, 'Homme', 'Angleterre');
INSERT INTO Netflix_Poly.Participant VALUES ('363131624', 'Valeria Wilson', 59 , 'Femme', 'États-Unis');
INSERT INTO Netflix_Poly.Participant VALUES ('646966259', 'Adele Hamilton', 49, 'Femme', 'France');

INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('219638939', 6, 'Réalisateur', 106969.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('761059237', 4, 'Acteur(e)', 154730.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('584026975', 3, 'Metteur en scène', 190709.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('192630275', 12, 'Maquilleur(euse)', 42081.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('928396142', 15, 'Effets visuels', 120535.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('520631649', 1, 'Caméraman', 34092.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('262816119', 6, 'Écrivain(e)', 134072.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('638012476', 8, 'Cinématographeur(euse)', 166092.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('668985112', 6, 'Génie Sonore', 133796.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('143464956', 9, 'Producteur', 193899.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('396012676', 7, 'Réalisateur', 143121.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('961854650', 5, 'Écrivain(e)', 147822.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('363131624', 4, 'Caméraman', 32494.00);
INSERT INTO Netflix_Poly.FilmeParticipant VALUES ('646966259', 11, 'Acteur(e)', 181164.00);

INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2012-02-26', 'Los Angeles, CA, États-Unis', 'Billy Crystal');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2013-02-24', 'Los Angeles, CA, États-Unis', 'Seth MacFarlane');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2014-03-02', 'Los Angeles, CA, États-Unis', 'Ellen DeGeneres');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2015-02-22', 'Los Angeles, CA, États-Unis', 'Neil Patrick Harris');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2016-02-28', 'Los Angeles, CA, États-Unis', 'Chris Rock');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2017-02-26', 'Los Angeles, CA, États-Unis', 'Jimmy Kimmel');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2018-03-04', 'Los Angeles, CA, États-Unis', 'Jimmy Kimmel');
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2019-02-24', 'Los Angeles, CA, États-Unis', NULL);
INSERT INTO Netflix_Poly.Oscar VALUES (DEFAULT, '2020-02-09', 'Los Angeles, CA, États-Unis', NULL);

INSERT INTO Netflix_Poly.Nomination_oscar VALUES(11, 1, 'Meilleure Actrice', TRUE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(3, 5, 'Meilleure Actrice dans un second rôle', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(2, 3, 'Meilleur Réalisateur', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(12, 6, 'Meilleur Metteur en scène', TRUE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(1, 7, 'Meilleur Acteur dans un second rôle', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(5, 2, 'Meilleure Costumes', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(7, 6, 'Meilleure Choréographie', TRUE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(5, 4, 'Meilleure Chanson Originale', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(9, 4, 'Meilleur Acteur', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(13, 2, 'Meilleur Réalisateur', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(4, 1, 'Meilleur Producteur', TRUE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(8, 3, 'Meilleur effets visuels', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(6, 4, 'Meilleur Acteur', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(6, 3, 'Meilleure Costumes', TRUE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(4, 6, 'Meilleur Producteur', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(14, 5, 'Meilleur Acteur dans un second rôle', TRUE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(9, 6, 'Meilleur Metteur en scène', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(7, 7, 'Meilleur Maquilleur', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(8, 8, 'Meilleur Actrice', FALSE);
INSERT INTO Netflix_Poly.Nomination_oscar VALUES(2, 6, 'Meilleur effets visuels', FALSE);

INSERT INTO Netflix_Poly.Visionnement VALUES(1, 3, '2019-03-20', '00:55');
INSERT INTO Netflix_Poly.Visionnement VALUES(1, 5, '2020-01-20', '01:17');
INSERT INTO Netflix_Poly.Visionnement VALUES(4, 8, '2020-03-20', '02:05');
INSERT INTO Netflix_Poly.Visionnement VALUES(3, 2, '2020-02-20', '01:43');
INSERT INTO Netflix_Poly.Visionnement VALUES(2, 4, '2019-06-20', '00:46');
INSERT INTO Netflix_Poly.Visionnement VALUES(6, 7, '2019-01-20', '01:17');
INSERT INTO Netflix_Poly.Visionnement VALUES(5, 6, '2019-04-20', '00:29');
INSERT INTO Netflix_Poly.Visionnement VALUES(4, 10, '2019-09-20', '01:34');
INSERT INTO Netflix_Poly.Visionnement VALUES(1, 14, '2019-10-20', '01:53');
INSERT INTO Netflix_Poly.Visionnement VALUES(3, 3, '2019-04-20', '02:22');
INSERT INTO Netflix_Poly.Visionnement VALUES(4, 2, '2019-05-20', '01:31');
INSERT INTO Netflix_Poly.Visionnement VALUES(5, 11, '2019-06-20', '00:54');
INSERT INTO Netflix_Poly.Visionnement VALUES(2, 12, '2020-01-20', '00:30');
INSERT INTO Netflix_Poly.Visionnement VALUES(3, 9, '2020-02-20', '01:45');
INSERT INTO Netflix_Poly.Visionnement VALUES(6, 1, '2019-05-20', '01:37');
INSERT INTO Netflix_Poly.Visionnement VALUES(3, 3, '2019-06-20', '00:58');
INSERT INTO Netflix_Poly.Visionnement VALUES(2, 2, '2019-08-20', '00:19');
INSERT INTO Netflix_Poly.Visionnement VALUES(5, 1, '2019-05-20', '01:25');
INSERT INTO Netflix_Poly.Visionnement VALUES(6, 7, '2020-03-20', '00:43');
INSERT INTO Netflix_Poly.Visionnement VALUES(4, 4, '2020-01-20', '01:01');


