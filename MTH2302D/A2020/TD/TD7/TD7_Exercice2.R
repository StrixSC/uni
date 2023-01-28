#                       TD 7


#     Exercice 2


#  Importation des données de Memoire.csv


setwd(dir="C:/Users/liljo/OneDrive/Bureau/TD7D_A2020") 

Memoire <- read.csv("Memoire.csv", header = TRUE, sep = ";",dec = ".")


Memoire   # Permet d'afficher les données stockées dans Memoire.csv

Y  <-  Memoire$stress  #  on  peut  utiliser  un  nom  de  variable  plus  court
Y
#================================  Question a  =======================================

#    Moyenne

MoyenneStress = mean(Memoire$stress)  # ou simplement mean(Y)
MoyenneStress

#   Ecart-type 

EcTypeStress = sd(Memoire$stress)
EcTypeStress

#  Cinquième percentile

PercentStress5 <- quantile(Memoire$stress, probs = c(0.05)) # ou simplement quantile(Y,0.05)
PercentStress5

#  Quatre-vingt quinzième percentile

PercentStress95 <- quantile(Memoire$stress, probs = c(0.95))
PercentStress95

#================================  Question b  =======================================


#   Méthode 1       graphique de probabilité normale et graphique quantile-quantile


qqnorm(Memoire$stress)                       # Sur échelle de proba normale
qqline(Memoire$stress, col="red", lwd=2)     # Quantile-quantile

# Non! ça n'a pas l'air normale



# Méthode 2   

hist(Memoire$stress)     

# rajouter à l'histogramme la courbe de densité d'une loi normale 
# et celle estimée pour les données

hist(Memoire$stress, col="lightblue",border="black", main=paste("Histogramme, densité normale et ajustée"),
     xlab="Pourcentages",ylab="Fréquences", freq=FALSE)

lines(density(Memoire$stress), lwd=2) # densité ajustée, lwd donne épaisseur de ligne
x = seq(0,18,length.out=500) # crée une séquence de 500 points entre 0 et 18

# densité d'une loi normale
lines(x, dnorm(x, mean(Memoire$stress), sd(Memoire$stress)), lwd=2, lty=3) 
# lty (line type) indique le type de ligne (pointillés, pleine...etc)




#================================  Question c  =======================================


# Moyenne selon la variable sexe


                         #  Femme

var_femme = var(Memoire$stress[Memoire$sexe=="femme"])
var_femme


moyenne_femme = mean(Memoire$stress[Memoire$sexe=="femme"])
moyenne_femme


                         # Homme

var_homme = var(Memoire$stress[Memoire$sexe=="homme"])
var_homme


moyenne_homme = mean(Memoire$stress[Memoire$sexe=="homme"])
moyenne_homme


# Conclusion: les femmes ont l'air  plus stressées

# Confirmation: Boxplot



boxplot(Memoire$stress~Memoire$sexe,
        col=c("lightpink","lightblue"),
        horizontal=TRUE,
        notch=FALSE,  # Permet de déciner des boites en forme de 8
        main=paste("Niveau de stress de",nrow(Memoire),"individus"),
        ylab="Sexe",
        las=1)











