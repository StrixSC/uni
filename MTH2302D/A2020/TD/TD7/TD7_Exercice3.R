#                       TD 7


#     Exercice 3


# Changement de répertoire

setwd(dir="C:/Users/liljo/OneDrive/Bureau/TD7D_A2020")   


#  Importation des données de Sites_web.csv

#Sites <- read.csv("Sites_web.csv", header = TRUE, sep = ";",dec = ".")

# On peut renommer les colonnes avec les noms V1, V2...etc:

Sites <- read.csv("Sites_web.csv", header = TRUE, sep = ";",dec = ".",col.names=c('v1','v2','v3','v4','v5','v6','v7','v8'))




Sites   # Permet d'afficher les données stockées dans Sites_web.csv


#================================  Question a  =======================================

# Moyenne, écart-type et médiane des variables V2 et V3:

summary(Sites$v2)   # affiche min, 1er quartile, médiane, moyenne, 3eme quartile et max

s2<-sd(Sites$v2)   # Ecart-type de 

cv2<-sd(Sites$v2)/mean(Sites$v2)

cat('moyenne =',mean(Sites$v2),', médiane =',median(Sites$v2),', écart-type = ', s2,
    ', coefficient de variation = ', cv2 )

summary(Sites$v3)
s3<-sd(Sites$v3)
cv3<-sd(Sites$v3)/mean(Sites$v3)
cat('moyenne =',mean(Sites$v3),', médiane =',median(Sites$v3),', écart-type = ', s3,
    ', coefficient de variation = ', cv3 )



#================================  Question b  =======================================


# Nuages de points simultané sur le même graphique: 

#  i)  v2=f(v3) pour chacune des équipes v4

layout(matrix(1:2,1,2)) # ceci permet de diviser la sortie graphique en 2
plot(Sites$v3[Sites$v4==1],Sites$v2[Sites$v4==1],main="équipe 1",col="red",lwd=2,
     xlab="Nombre de commandes",ylab="Nombre de sites")

plot(Sites$v3[Sites$v4==13],Sites$v2[Sites$v4==13],main="équipe 13",col="blue", lwd=2,
     xlab="Nombre de commandes",ylab="Nombre de sites")





# ii) v2=f(v3) selon l'expérience v5

layout(matrix(1:2,1,2)) # ceci permet de diviser la sortie graphique en 2
plot(Sites$v3[Sites$v5==6],Sites$v2[Sites$v5==6],main="Expérience 6",col="blue",lwd=2,
     xlab="Nombre de commandes",ylab="Nombre de sites")

plot(Sites$v3[Sites$v5==12],Sites$v2[Sites$v5==12],main="Expérience 12",col="red", lwd=2,
     xlab="Nombre de commandes",ylab="Nombre de sites")



#================================  Question c  =======================================

layout(matrix(1:2,1,2)) # ceci permet de diviser la sortie graphique en 2
plot(Sites$v5,Sites$v2,col="blue",lwd=2,
     xlab="Expérience",ylab="Nombre de sites")

abline(lm(Sites$v2~Sites$v5), col="red")               # regression line (y=v2~x=v5)

lm(Sites$v2~Sites$v5)       #   fournit deux valeurs, dans l'ordre: l'ordonnée à l'origine "b"
                            #   et la pente "a" de la droite de régression linéaire (L):y=ax+b


plot(Sites$v5,Sites$v3,col="red", lwd=2,               
     xlab="Expérience",ylab="Carnet de commandes")

abline(lm(Sites$v3~Sites$v5), col="red")               # regression line (y=v3~x=v5)
lm(Sites$v3~Sites$v5)

#================================  Question d  =======================================

#layout(matrix(1,1,1))

qqnorm(Sites$v2)
qqline(Sites$v2)            # Sans couleur




qqnorm(Sites$v2)                       
qqline(Sites$v2, col="red", lwd=2)

# Non, la normalité n'est pas possible

#================================  Question e  =======================================

# v2: Avant modification 

summary(Sites$v2[Sites$v6==0])
sd(Sites$v2[Sites$v6==0])

# v2: Après modification

summary(Sites$v2[Sites$v6==1])
sd(Sites$v2[Sites$v6==1])


# v3: Avant modification 

summary(Sites$v3[Sites$v6==0])
sd(Sites$v3[Sites$v6==0])

# v3: Après modification

summary(Sites$v3[Sites$v6==1])
sd(Sites$v3[Sites$v6==1])


#   Les Boxplots

layout(matrix(1:2,1,2))
boxplot(Sites$v2~Sites$v6,col="lightpink", main=paste("V2"))  # Boxplot de v2 pour chaque valeur de v6

boxplot(Sites$v3~Sites$v6,col="lightblue", main=paste("V3"))  # Boxplot de v3 pour chaque valeur de v6


