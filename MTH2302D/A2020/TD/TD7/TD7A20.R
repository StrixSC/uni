

# Changement de répertoire

setwd(dir="C:/Users/liljo/OneDrive/Bureau/TD7D_A2020") 

#  Importation des données de Coton.csv

Coton = read.csv("Coton.csv", header = TRUE, sep = ";",dec = ",",col.names=c('PERCENT'))

Coton  # Permet d'afficher les données stockées dans Coton.csv. Coton est elle-même une
# base de données

