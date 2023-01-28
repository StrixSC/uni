
#                                              TD 9 




##                                          Exercice 1




### a) 

# Importation des données.


setwd(dir="C:/Users/liljo/Dropbox/MTH2302D/Via_A2020/TD9")


distribution_moyenne <- read.csv("distribution_moyenne.csv", header = TRUE, sep = ";",dec = ",")
distribution_moyenne   # Permet d'afficher les données stockées dans distribution_moyenne.csv






# Séparation des ensembles de données.


distribution_moyenne_n1 = distribution_moyenne[,1]          # Extrait la 1ere colonne de "distribution_moyenne.csv"
distribution_moyenne_n3 = distribution_moyenne[,1:3]        # Extrait les colonnes 1 à 3
distribution_moyenne_n10 = distribution_moyenne[,1:10]      # Extrait les colonnes 1 à 10
distribution_moyenne_n30 = distribution_moyenne[,1:30]      # Extrait les colonnes 1 à 30


# Calcul de la moyenne de chaque ligne.


moyenne_n1 = distribution_moyenne_n1                   # Pas besoin de rowMeans() car ici chaque ligne contient 1 seule colonne

moyenne_n3 = rowMeans(distribution_moyenne_n3)         # rowMeans calcule la moyenne sur chaque ligne

moyenne_n10 = rowMeans(distribution_moyenne_n10)

moyenne_n30 = rowMeans(distribution_moyenne_n30)




# Les Histogrammes

par(mfcol=c(2,2))                   # Création de (m=2)*(n=2)=4 fenêtres d'affichage

par(mar=c(4,4,4,4))            # définit les marges inférieure, gauche, supérieure et droite 
                               # respectivement de la région de tracé en nombre de lignes de texte.


hist(moyenne_n1,main=expression("Histogramme de "~bar(X)~" pour "~ n==1),xlab=expression(bar(X)),ylab="Fréquence",col="green")

hist(moyenne_n3,main=expression("Histogramme de "~bar(X)~" pour "~ n==3),xlab=expression(bar(X)),ylab="Fréquence",col="blue")

hist(moyenne_n10,main=expression("Histogramme de "~bar(X)~" pour "~ n==10),xlab=expression(bar(X)),ylab="Fréquence",col="red")

hist(moyenne_n30,main=expression("Histogramme de "~bar(X)~" pour "~ n==30),xlab=expression(bar(X)),ylab="Fréquence",col="yellow")





# graphiques de probabilité normale et graphiques quantile-quantile

par(mfcol=c(2,2))                     
par(mar=c(4,4,4,4))

qqnorm(moyenne_n1); qqline(moyenne_n1, col="green", lwd=2)

qqnorm(moyenne_n3); qqline(moyenne_n3, col="blue", lwd=2)

qqnorm(moyenne_n10); qqline(moyenne_n10, col="red", lwd=2)

qqnorm(moyenne_n30); qqline(moyenne_n30, col="yellow", lwd=2)


# Calcul des statistiques descriptives pour n=1, 3, 10, 30.

#  Moyennes 
moy_moy = c(mean(moyenne_n1),mean(moyenne_n3),mean(moyenne_n10),mean(moyenne_n30))
moy_moy 

# Variances

var_moy = c(var(moyenne_n1),var(moyenne_n3),var(moyenne_n10),var(moyenne_n30))
var_moy

n_moy = c(1,3,10,30)

var_moy_n = var_moy*n_moy       # calcul de n*Var(Xbar)  (permet de répondre à la question b.)
var_moy_n

# Création d'un tableau (data.frame)

stat_descriptives = data.frame("Moyenne"=moy_moy,"Variance"=var_moy,"n"=n_moy,"Variance fois n"=var_moy_n)
stat_descriptives

### b) Les valeurs sur la dernière colonne du tableau précédent sont proches de 1= variance d'une exponentielle(lambda=1)


#========================================================================================================================





##                                                Exercice 2
#                                                 =-=-=-=-=-




# Nettoyer l'environnement et la fenêtre de graphique.

rm(list = ls())        #          supprime tous les objets de l'espace de travail courant 






# Importation des données.


intervalle_confiance <- read.csv("intervalle_confiance.csv", header = TRUE, sep = ";",dec = ",")
intervalle_confiance   # Permet d'afficher les données stockées dans intervalle_confiance.csv



#### a) Par définition, t est le quantile d'ordre 1-alpha/2 de la loi de student à n-1 degrés de liberté
#       Par le tableau IV, Page 513 de la 3e édition du livre de cours, on trouve: 
#       t = 2.262
# Sous R, on a:

t = qt(1-0.05/2, 9)     
t                         # ou encore, 

tt = qt(0.05/2, 9, lower.tail = FALSE)
tt


### b)

#### b.1)
# Matrice des simulations

M = numeric()                   # Initialisation de M: matrice à valeurs numériques (initialement vide)

for(i in 1:950){
  #set.seed(i)
  M = rbind(M,rnorm(10, mean = 2, sd = 2))
}                                                  # Faire class(M) pour connaitre la nature de M 

                                                   # Faire dim(M) pour connaitre les dimensions de M

M=as.data.frame(M)
names(M)=c('X1','X2','X3','X4','X5','X6','X7','X8','X9','X10')
intervalle_confiance_2 = rbind(intervalle_confiance,M)            # Faire   dim(intervalle_confiance_2)


#### b.2)
# Éléments nécessaires aux calculs

moyenne = apply(intervalle_confiance_2, 1, mean)    # Moyenne ligne par ligne  (remplacer 1 par 2 s'il s'agit des colonnes)
variance = apply(intervalle_confiance_2, 1, var)    # Variance ligne par ligne
n = 10
# Le quantile t est déjà calculé

# Calculs des intervalles de confiance

Borne_inf = moyenne - (t*sqrt(variance/n))
Borne_sup = moyenne + (t*sqrt(variance/n))

IC = data.frame(Borne_inf,Borne_sup)      # Utiliser la commande IC[1:5,] pour afficher les 5 premières lignes de IC





#### b.3)
sum((Borne_inf<=2)*(Borne_sup>=2))/1000


#### c)  L'intervalle de confiance n'est pas une estimation ponctuelle. C'est "X bar" qui est un estimateur ponctuel. 
#        On dispose de 1000 observations de "X bar" dans le vecteur "moyenne". Pour avoir une estimation de la moyenne 
#        de la population, la loi forte des grands nombres nous suggère de calculer 
        
         mean(moyenne)                                  # Le résultat donne 2 approximativement.           


#=========================================================================================================================         
         
         
         
         
         
         
         
##                                                     Exercice 3
#                                                      =-=-=-=-=-
         
         
         
# Nettoyer l'environnement et la fenêtre de graphique.
rm(list = ls())




#### a)

#### b)

##### b.1)
# Matrice des simulations
intervalle_confiance_exp = numeric()
for(i in 1:1000){
 #set.seed(i)
  intervalle_confiance_exp = rbind(intervalle_confiance_exp,rexp(50, rate = 0.5))  #
}

##### b.2) Intervalle de confiance pour chaque échantillon


# Éléments nécessaires aux calculs


moyenne_exp = apply(intervalle_confiance_exp, 1, mean)

variance_exp = apply(intervalle_confiance_exp, 1, var)

n = 50  
alpha = 0.05
z = qnorm(1-alpha/2,0,1)    # ou simplement qnorm(1-alpha/2) lorsqu'il s'agit du N(0,1)
# Calculs des intervalles de confiance
Borne_sup_exp = moyenne_exp + (z*sqrt(variance_exp/n))
Borne_inf_exp = moyenne_exp - (z*sqrt(variance_exp/n))
IC = data.frame(Borne_inf_exp,Borne_sup_exp)


#### b.3)


sum((Borne_inf_exp<2)*(Borne_sup_exp>2))/1000







