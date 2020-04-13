-- 1) Affichez toutes les informations sur un film spécifié par l'utilisateur (selon le titre)
-- Changer le titre par n'importe quel titre de filme.

SELECT * FROM Netflix_Poly.Filme AS F
WHERE F.Titre = 'Avengers: Infinity War';

-- 2) Pour chaque genre de film, listez tous les titres de films ainsi que la dernière date à laquelle
-- un film a été acheté (DVD) ou visionné

SELECT DISTINCT  F.genre AS "Genre du Filme", F.Titre, MAX(CO.Date_Envoi) AS "Achat le plus récent", 
MAX(V.Date_Visionnement) AS "Visionnement le plus récent" FROM Netflix_Poly.Filme AS F
JOIN Netflix_Poly.DVD AS D ON D.NoFilme = F.NoFilme
JOIN Netflix_Poly.Commande AS CO ON CO.NoDVD = D.ID_Dvd
JOIN Netflix_Poly.Visionnement AS V ON F.NoFilme = F.NoFilme
GROUP BY F.Genre, F.Titre
ORDER BY F.Genre;

-- 3) Pour chaque genre de film, trouvez les noms et courriels des membres qui les ont visionnés le
-- plus souvent. Par exemple, Amal Z est le membre qui a visionné le plus de documentaires
-- animaliers

    -- TODO

-- 4) Trouvez le nombre total de films groupés par réalisateur
SELECT Pa.Nom, COUNT(F.Titre) AS "Nombre total de filmes" FROM Netflix_Poly.Participant AS Pa
NATURAL JOIN Netflix_Poly.FilmeParticipant AS FP
NATURAL JOIN Netflix_Poly.Filme AS F
WHERE FP.Role = 'Réalisateur'
GROUP BY Pa.Nom;


-- 5) Trouvez les noms des membres dont le coût total d’achat de DVD est plus élevé que la
-- moyenne

SELECT DISTINCT MEM.Nom FROM Netflix_Poly.Membre AS MEM
NATURAL JOIN Netflix_Poly.Commande AS CO
WHERE CO.Cout > (
    SELECT AVG(CO.Cout) FROM Netflix_Poly.Commande AS CO 
);

-- 6) Ordonnez et retournez les films en termes de quantité totale vendue (DVD) et en nombre de
-- visionnements

SELECT F.Titre, COUNT(F.Titre) AS "Nombre d`Achat" FROM Netflix_Poly.Filme AS F
JOIN Netflix_Poly.DVD AS D ON D.NoFilme = F.NoFilme
JOIN Netflix_Poly.Commande AS CO ON CO.NoDvd = D.ID_Dvd
JOIN Netflix_Poly.Visionnement AS V ON V.NoFilme = F.NoFilme
GROUP BY (F.Titre);

SELECT * FROM Netflix_Poly.Commande AS CO
INNER JOIN Netflix_Poly.DVD AS D ON D.ID_Dvd = CO.NoDvd
INNER JOIN Netflix_Poly.Filme AS F ON F.NoFilme = D.NoFilme
INNER JOIN Netflix_Poly.Visionnement AS V ON V.NoFilme = F.NoFilme;

SELECT F.Titre, COUNT(F.Titre) FROM Netflix_Poly.Filme AS F
INNER JOIN Netflix_Poly.Visionnement AS V ON V.NoFilme = F.NoFilme
GROUP BY F.Titre;