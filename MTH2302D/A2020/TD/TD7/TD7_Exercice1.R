
#                       TD 7


#     Exercice 1





# Changement de répertoire

setwd(dir="C:/Users/liljo/OneDrive/Bureau/TD7D_A2020")        #C:

#  Importation des données de Coton.csv

Coton <- read.csv("Coton.csv", header = TRUE, sep = ";",dec = ",",col.names=c('PERCENT'))

Coton   # Permet d'afficher les données stockées dans Coton.csv. Coton est elle-même une
        # base de données

X<- Coton$PERCENT # Permet de choisir un nom de variable plus court.
X
#======================================================================================

# Analyse statistique complète de la variable "PERCENT"

#======================================================================================


#                      Histogramme

hist(Coton$PERCENT)        # Cas simple 

# Ou bien en utilisant le nom de la variable, c'est-à-dire X
hist(X)

#--------------------------------------------------------------------------------------

hist(Coton$PERCENT, col="lightpink",border="black", main=paste("HISTOGRAMME"),
     xlab="Pourcentages de coton",ylab="Fréquences")

# Ou bien en utilisant le nom de la variable, c'est-à-dire X
hist(X, col="lightpink",border="black", main=paste("HISTOGRAMME"),
     xlab="Pourcentages de coton",ylab="Fréquences")
#======================================================================================


#                     Tableau d'effectifs


TabEff=table(Coton$PERCENT)                # ou bien TabEff=table(X)
TabEff                    # Affiche le tableau



# Pour obtenir un tableau des fréquences, il faut créer des limites de classes

breaks  <-seq(32,38,by=1)  #  by donne la longueur de l'intervalle (essayer différentes  valeurs)
breaks

classx  <-  factor(cut(Coton$PERCENT,  breaks))  # ou bien, remplacer Coton$PERCENT par X

xout  <-  as.data.frame(table(classx))
xout       # Tableau des fréquences

# On peut ajouter des effectifs cumulés et des fréquences relatives: 
# Voir page 4 du pdf TD7-MTH2302D

#======================================================================================

#        Diagramme de boite à moustaches (Boxplot)


boxplot(Coton$PERCENT) # Cas le plus simple

boxplot(Coton$PERCENT,
        col=c("lightblue"),
        horizontal=TRUE,
        notch=TRUE,                    # Permet de déciner des boites en forme de 8
        main=paste("Pourcentages de coton"),
        ylab="Lot de tissus No1",
        las=1)

#======================================================================================

#        graphique de probabilité normale et graphique quantile-quantile


qqnorm(Coton$PERCENT)                       # Sur échelle de proba normale
qqline(Coton$PERCENT, col="red", lwd=2)     # Quantile-quantile



#=====================================================================================

#    Moyenne, variance, écart-type, coefficient de variation, médiane, q1, q3, eiq


m=mean(X)  # ou bien m=mean(Coton$PERCENT): Moyenne de X ou de Coton$PERCENT

md=median(X) # Médiane de X

v=var(X)  # Variance de X

s=sd(X)   # Ecart-type de X, (sd= "standard deviation" en anglais)

cv=s/m    # Coefficient de variation

# cat() permet d'afficher et est utiliser de la façon suivante:
cat('moyenne =',m,', médiane =',md,', écart-type =',s,', variance =',v,'\n',
    'coefficient de variation =',cv)

# La commande 'summary()' donne certaines statistiques : le minimum, le 1er quartile,
# la médiane, la moyenne, le 3eme quartile et le maximum.

summary(X)

# Les percentiles de tout ordre peuvent être calculés avec la commande quantile(X, ordres)

quantile(X, 0.5)  # la médiane

quantile(X, c(0.25,0.5,0.75))  # pour les 3 quartiles

# L'écart inter quartile (commande IQR)

IQR(X)


                 #Autre façon: présenter les résultats sous forme d'un tableau


#     Création d'un tableau de calculs

# Initialisation du data.frame

mesures = data.frame(paramètres=c("Valeurs"),moyenne=NA, var=NA, s=NA, q1=NA, mediane=NA,
                     q3=NA, cv=NA, eiq=NA)

mesures

#moyenne
mesures$moyenne = sapply(1, function(i) mean(Coton[,i]))

# écart-type
mesures$s = sapply(1, function(i) sd(Coton[,i]))

# Variance
mesures$var=(mesures$s)^2

# Coefficient de variation
mesures$cv=mesures$s / mesures$moyenne

# mediane
mesures$mediane = sapply(1, function(i) median(Coton[,i]))

# quantiles q1 et q3
mesures[1, c("q1", "q3")] = quantile(Coton$PERCENT, probs = c(0.25,0.75))

# Ecart interquartile
mesures$eiq = mesures$q3 - mesures$q1




















