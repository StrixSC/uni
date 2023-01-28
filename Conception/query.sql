-- 1) Affichez toutes les informations sur un film spécifié par l'utilisateur (selon le titre)
-- Changer le titre par n'importe quel titre de filme.

SELECT * 
FROM Netflix_Poly.Filme AS F
WHERE F.Titre = 'Avengers: Infinity War';

-- 2) Pour chaque genre de film, listez tous les titres de films ainsi que la dernière date à laquelle
-- un film a été acheté (DVD) ou visionné

SELECT DISTINCT  F.genre AS "Genre du Filme", F.Titre AS "Titire du Filme",
				    CASE
					  WHEN MAX(CO.Date_Envoi) IS NULL AND MAX(V.Date_Visionnement) IS NULL THEN NULL  
					  WHEN MAX(CO.Date_Envoi) > MAX(V.Date_Visionnement) THEN MAX(CO.Date_Envoi)
					  ELSE MAX(V.Date_Visionnement) 
   					END AS "Derniere date visionné ou acheté"
FROM Netflix_Poly.Filme AS F
FULL OUTER JOIN Netflix_Poly.DVD AS D ON D.NoFilme = F.NoFilme
FULL OUTER JOIN Netflix_Poly.Commande AS CO ON CO.NoDVD = D.ID_Dvd
JOIN Netflix_Poly.Visionnement AS V ON F.NoFilme = F.NoFilme
GROUP BY F.Genre, F.Titre
ORDER BY F.Genre;

-- 3) Pour chaque genre de film, trouvez les noms et courriels des membres qui les ont visionnés le
-- plus souvent. Par exemple, Amal Z est le membre qui a visionné le plus de documentaires
-- animaliers   

SELECT MAX(nb_visionnement.visionnement) AS "Nombre de vue maximal",
		nb_visionnement.memNom AS "Nom",
		nb_visionnement.memCourriel AS "Courriel"
FROM (SELECT DISTINCT COUNT(F.genre) AS visionnement, 
						Mb.nom AS memNom, Mb.courriel AS memCourriel, F.genre AS genre
	  FROM Netflix_Poly.Visionnement AS V
	  INNER JOIN Netflix_Poly.Membre AS Mb ON V.id_membre = Mb.id_membre
	  LEFT JOIN Netflix_Poly.Filme AS F ON V.nofilme = F.nofilme
	  GROUP BY F.genre, Mb.id_membre, Mb.courriel) AS nb_visionnement,
	  Netflix_Poly.Filme AS F
WHERE nb_visionnement.genre = F.genre
GROUP BY  nb_visionnement.memNom, nb_visionnement.memCourriel;

-- 4) Trouvez le nombre total de films groupés par réalisateur

SELECT Pa.Nom AS "Nom du Realisateur", COUNT(F.Titre) AS "Nombre total de filmes" 
FROM Netflix_Poly.Participant AS Pa
NATURAL JOIN Netflix_Poly.FilmeParticipant AS FP
NATURAL JOIN Netflix_Poly.Filme AS F
WHERE FP.Role = 'Réalisateur'
GROUP BY Pa.Nom;


-- 5) Trouvez les noms des membres dont le coût total d’achat de DVD est plus élevé que la
-- moyenne

SELECT DISTINCT Mb.Nom AS "Nom du Membre"
FROM Netflix_Poly.Membre AS Mb
NATURAL JOIN Netflix_Poly.Commande AS CO
WHERE CO.Cout > (
    SELECT AVG(CO.Cout) 
	FROM Netflix_Poly.Commande AS CO 
);

-- 6) Ordonnez et retournez les films en termes de quantité totale vendue (DVD) et en nombre de
-- visionnements

SELECT V.Titre AS "Titre du Filme", V.visionnements AS "Nbre de visionnements", 
	   Q.vendues AS "Quantite de DVD vendu"
FROM (	SELECT F.Titre AS Titre, COUNT(V.NoFilme) AS visionnements
		FROM Netflix_Poly.Filme AS F
		INNER JOIN Netflix_Poly.Visionnement AS V ON V.NoFilme = F.NoFilme
		GROUP BY F.Titre	) AS V,
	 (	SELECT F.titre AS Titre, COUNT(CO.nodvd) AS vendues
		FROM Netflix_Poly.Commande AS CO
		LEFT JOIN Netflix_Poly.DVD AS D ON CO.nodvd = D.id_dvd
		RIGHT JOIN Netflix_Poly.Filme AS F ON D.nofilme = F.nofilme
		GROUP BY F.titre, D.id_dvd) AS Q
WHERE V.TITRE = Q.TITRE;

-- 7) Trouvez le titre et le prix des films qui n’ont jamais été commandés sous forme de DVD mais qui
-- ont été visionnés plus de 10 fois

SELECT DISTINCT F.titre AS "Titre du Filme", F.prix AS "Prix du Filme", 
				COUNT(*) AS "Nbre de visionnement"
FROM Netflix_Poly.Filme AS F
LEFT JOIN  Netflix_Poly.DVD 		 AS D ON F.nofilme = D.nofilme 
INNER JOIN Netflix_Poly.Visionnement AS V ON F.nofilme = V.nofilme
WHERE D.id_dvd NOT IN (SELECT DISTINCT D.id_dvd 
						FROM Netflix_Poly.Commande AS CO
						WHERE CO.nodvd = D.id_dvd )
GROUP BY F.nofilme, V.nofilme, D.id_dvd
HAVING COUNT(*) > 10;

--  8) Trouvez le nom et date de naissance des acteurs qui jouent dans les films qui sont visionnés le 
--  plus souvent (soit plus que la moyenne)

SELECT DISTINCT PA.nom AS "Nom du Participant",
				(EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - PA.age) AS "Année de Naissance",
				COUNT(*) AS "Nb de Visionnements Du Filme"
FROM Netflix_Poly.Filmeparticipant AS FP
INNER JOIN Netflix_Poly.Participant 	 AS PA ON PA.nas 	= FP.nas
LEFT JOIN Netflix_Poly.Visionnement	 	 AS V  ON FP.nofilme = V.nofilme
WHERE FP.Role = 'Acteur(e)'
GROUP BY PA.nom, PA.age
HAVING COUNT(*) > (SELECT CAST(AVG(count) AS DECIMAL(5,2)) AS "Moyenne"
					FROM (
						SELECT COUNT(*) AS Count
						FROM Netflix_Poly.Filme AS F
						RIGHT JOIN Netflix_Poly.Visionnement AS V ON F.nofilme = V.nofilme
						GROUP BY F.nofilme, V.nofilme) as counts);

-- 9) Trouvez le nom du ou des réalisateurs qui ont réalisé les films qui ont le plus grand nombre 
-- de nominations aux oscars.  Par exemple, Woody Allen et Steven Spielberg ont réalisé 10 films qui
-- ont été nominés aux oscars.

SELECT DISTINCT PA.nom AS "Nom du Réalisateur", COUNT(NOS.nofilme) AS "Nb de Filmes Nominés"
FROM Netflix_Poly.FilmeParticipant AS FP
INNER JOIN Netflix_Poly.Nomination_oscar AS NOS ON NOS.nofilme = FP.nofilme
INNER JOIN Netflix_Poly.Participant 	 AS PA  ON PA.nas = FP.nas
WHERE FP.Role = 'Réalisateur'
GROUP BY PA.nom, FP.nofilme, NOS.nomination
HAVING COUNT(NOS.nofilme) = (SELECT MAX(count) AS "Max nominations"
							FROM (
								SELECT COUNT(FP.nofilme) AS Count
								FROM Netflix_Poly.FilmeParticipant AS FP
								INNER JOIN Netflix_Poly.Nomination_oscar AS NOS ON NOS.nofilme = FP.nofilme
								INNER JOIN Netflix_Poly.Participant 	 AS PA  ON PA.nas = FP.nas
								WHERE FP.Role = 'Réalisateur'
								GROUP BY PA.nom, FP.nofilme, NOS.nomination) as counts);

-- 10) Trouvez le nom des réalisateurs qui ont été le plus souvent nominés aux oscars mais qui n’ont 
-- jamais gagné d’oscar 

SELECT DISTINCT PA.nom AS "Nom du Réalisateur", COUNT(NOS.nofilme) AS "Nb de nominations"
FROM Netflix_Poly.Filmeparticipant AS FP
INNER JOIN Netflix_Poly.Nomination_oscar AS NOS ON NOS.nofilme = FP.nofilme
INNER JOIN Netflix_Poly.Participant 	 AS PA  ON FP.nas = PA.nas
WHERE FP.Role = 'Réalisateur'
AND NOS.nomination = 'Meilleur Réalisateur'
GROUP BY PA.nom
HAVING COUNT(NOS.nofilme) = (SELECT MAX(count) AS "Max nominations"
							FROM (
								SELECT COUNT(FP.nofilme) AS Count
								FROM Netflix_Poly.FilmeParticipant AS FP
								INNER JOIN Netflix_Poly.Nomination_oscar AS NOS ON NOS.nofilme = FP.nofilme
								INNER JOIN Netflix_Poly.Participant 	 AS PA  ON PA.nas = FP.nas
								WHERE FP.Role = 'Réalisateur'
								AND NOS.gagnant = FALSE
								GROUP BY PA.nom, FP.nofilme, NOS.nomination) as counts);


-- 11) Trouvez  les  films  (titre,  année)  qui  ont  gagné  le  plus  d’oscars.  Listez  également  leur 
-- réalisateurs et leurs acteurs 

SELECT DISTINCT F.titre AS "Filmes Ayant le plus de Oscars",  EXTRACT(YEAR FROM f.date_production) AS "Annee", 
				COUNT(NOS.gagnant) AS "Nb Oscars Gagnes", PA.nom AS "Nom du participant", FP.role   AS "Role"
FROM Netflix_Poly.Filme AS F
INNER JOIN Netflix_Poly.Nomination_oscar AS NOS ON NOS.nofilme = F.nofilme
INNER JOIN Netflix_Poly.Filmeparticipant AS FP ON FP.nofilme = F.nofilme
INNER JOIN Netflix_Poly.Participant AS PA ON FP.nas = PA.nas
WHERE NOS.gagnant = true
AND FP.role = 'Acteur(e)' OR FP.role = 'Réalisateur'
GROUP BY f.titre, EXTRACT(YEAR FROM f.date_production), PA.nom, FP.role
HAVING COUNT(NOS.gagnant) = (SELECT MAX(count) AS "Max Gagnants"
								FROM (
									SELECT DISTINCT F.titre AS "Titre du Filme",  EXTRACT(YEAR FROM f.date_production) AS "Annee", 
													COUNT(NOS.gagnant) AS Count
									FROM Netflix_Poly.Filme AS F
									INNER JOIN Netflix_Poly.Nomination_oscar AS NOS ON NOS.nofilme = F.nofilme
									AND NOS.gagnant = true
									GROUP BY f.titre, EXTRACT(YEAR FROM f.date_production)) as counts)
ORDER BY EXTRACT(YEAR FROM f.date_production) DESC;

-- 12) Quelles paires de femmes québécoises ont le plus souvent travaillé ensemble dans différents films ?

SELECT F.titre, PA.nom, COUNT(*) AS Counter
FROM Netflix_Poly.Participant PA
INNER JOIN Netflix_Poly.FilmeParticipant FP ON PA.nas = FP.nas 
INNER JOIN Netflix_Poly.Filme F  ON F.nofilme = FP.nofilme
WHERE PA.nationalite = 'Quebec'
GROUP BY F.titre, PA.nom;

-- 13) Comment a évolué la carrière de Woody Allen ? (On veut connaitre tous ses rôles dans un film
-- (réalisateur, acteur, etc.) du plus ancien au plus récent) 

SELECT  PA.nom AS "Nom du Participant", F.titre AS "Titre du Filme", 
		F.date_production AS "Date de Production", FP.role AS "Role"
FROM Netflix_Poly.Filme AS F
INNER JOIN Netflix_Poly.FilmeParticipant AS FP ON F.nofilme = FP.nofilme 
INNER JOIN Netflix_Poly.Participant AS PA ON FP.nas = PA.nas 
AND PA.nom = 'Woody Allen'
GROUP BY PA.nom, F.titre, F.date_production, FP.role 
ORDER BY F.date_production ASC;





