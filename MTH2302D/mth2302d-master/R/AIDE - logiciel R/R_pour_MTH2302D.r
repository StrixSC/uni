rm(list=ls()) 
pnorm(2) - pnorm(0)        # question a)
pnorm(1) - pnorm(-1)       # question b)
pnorm(1.65)                # question c)
1-pnorm(-1.96)             # question d)
2*(1-pnorm(1.5))           # question e)
pnorm(2) - pnorm(-1.9)     # question f)
pnorm(1.37)                # question g)
pnorm(2.57) - pnorm(-2.57) # question h)

qnorm(0.94062)       # question a). [Même résultat avec qnorm(0.05938,lower.tail=F)]
qnorm(0.975)         # question b). [Même résultat avec qnorm(0.025,lower.tail=F)]
qnorm(0.995)         # question c). [Même résultat avec qnorm(0.005,lower.tail=F)]
qnorm(0.05)          # question d). [Même résultat avec qnorm(0.95,lower.tail=F)]

set.seed(123) # on fixe le germe, ceci permet de générer toujours les mêmes données 
x <- rnorm(100, 5, 3)  # on génère des observations (ici 100). 
# Ici les données sont placées dans la variable x. Exemple :
x 

hist(x)

hist(x, col="green", main="Histogramme de x", xlab="valeurs de x", 
     ylab="Nombre d'observations")

boxplot(x, col="grey", horizontal=T)

# par défaut la boîte est verticale. 
# L'option 'horizontal=TRUE' la place horizontalement
# D'autre options sont disponibles. 
# Pour plus de détails, taper ?boxplot() dans la console de R

summary(x)

m=mean(x)  # la moyenne
s=sd(x)    # l'écart type
v=var(x)
n=length(x)
# et les écrire
cat('la moyenne =',m,', l\'écart-type = ', s,', la variance = ', v ,'\n',
    ' et la taille de l\'échatillon est n =',n,'.')

shapiro.test(x) # calcule et affiche les valeurs de W et p

qqnorm(x, main ="Diagramme de probabilités normal - ou Q-Q Plot of x")
qqline(x)      # pour ajouter une droite

# On crée une variable, disons nbh, pour le nombre d'heures
nbh <- c(8.8, 12.5, 5.4, 12.8, 8.8, 12.2, 13.3, 6.9, 9.1, 14.7, 2.2)
# on peut visualiser les données
nbh

# test de normalité si nécessaire
shapiro.test(nbh)

t.test(nbh, mu = 8, alternative = "greater") 
# alternative donne le sens du test de l'inégalité dans $H_1$. 
# On a donc aussi : "less" pour inférieur, 
# et "two.sided" pour bilatéral.

qt(.95,10)
1-pt(1.4745,10)
# Si on veut, on peut toujours calculer soi-même la moyenne, l'écart type, etc. 
mean(nbh) 
sd(nbh)
# ou la valeur de t
(mean(nbh) - 8)/(sd(nbh)/sqrt(length(nbh)))


alpha=0.05  # la valeur de alpha
mu0=40      # la valeur de mu0
xbar=41.25  # la valeur de la moyenne xbar
sigma=2     # la valeur de l'écat type sigma
n=25        # le nombre d'observations
z0=(xbar - mu0)/(sigma/sqrt(n)) 
pval=2*(1-pnorm(abs(z0)))
zalpha2=qnorm(1-alpha/2)
cat('Résultats :','\n')
cat('z0 =',z0,';','zalpha2 =',zalpha2,';','p-value=',pval)

x1 <- c(24.2, 26.6, 25.7, 24.8, 25.9, 26.5)
x2 <- c(21.0, 22.1, 21.8, 20.9, 22.4, 22.0)

# on peut vérifier l'hypothèse de la normalité des données
shapiro.test(x1)
shapiro.test(x2)

var.test(x1,x2)

qf(.025,5,5)   # ou encore qf(.975,5,5, lower.tail=F)
qf(.975,5,5)   # ou encore qf(.025,5,5, lower.tail=F)

t.test(x1,x2, var.equal=T)

don <- read.csv2("Exerc12_5.csv") 
# les données sont lues et placées dans une base de données appelée ici 'don'

# La commande read.csv2("fichier.csv") permet de lire les 
# fichiers .csv dont la décimale des chiffres est une virgule
# dans le cas contraire on urilise read.csv("fichier.csv")

#attach(don) # cette commande permet d'attacher les données 
# en mémoire et d'y accéder directement avec les noms des variables

# don <- read.csv("Exerc12_5.csv", header = TRUE, sep = ";", dec = ".")

# On peut visualiserles les données en invoquant le nom de la base de données
don

plot(don$X,don$Y,col="blue")

reg.lin <- lm(Y~X, data=don)

plot(don$X, don$Y, col="blue", main="Le nuage de points et la droite de régression", xlab="Température", ylab="Quantité")
abline(reg.lin, col="red")

summary(reg.lin)

confint(reg.lin)

confint(reg.lin, level=.90)

anova(reg.lin)

newd <- data.frame(X = c(60)) # on détermine x0 (ici 60)
predict(reg.lin, newd, interval = "prediction") 
# intervalle prédiction au point X=60 à 95% formule (12.25) page 409
predict(reg.lin, newd, interval = "confidence") 
# intervalle de confiance pour la moyenne au point X=60 à 95%
# formule (12.23) page 407

newd <- data.frame(X = c(60,65,70))
predict(reg.lin, newd, interval = "prediction") 
predict(reg.lin, newd, interval = "confidence") 

plot(reg.lin,1:2)
