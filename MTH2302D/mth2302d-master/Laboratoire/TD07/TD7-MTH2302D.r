
coton <- read.csv2("Coton.csv")  # les données sont lues et placées dans une base de données, ici 'coton'.
# si cette commande ne focntionne pas, essayer celle-ci
# coton <- read.csv("Coton.csv", header = TRUE, sep = ";",dec = ".")

coton  # on peut visualiser l'ensemble des données en tapant le nom de la base de données

x <- coton$Pourcentage.de.coton # on peut choisir un nom de variable plus court, e.g. ici, x

x # on peut voir les données d'une variable en tapant le nom de la variable

hist(x,col="green",main="Histogramme du pourcentage de coton", 
     border="red", xlab="Pourcentage",ylab="Effectif")

breaks <-seq(32,38,by=1) # by donne la longueur de l'intervalle (essayer différentes valeurs)

breaks

classx <- factor(cut(x, breaks))

xout <- as.data.frame(table(classx))
xout

xout <- transform(xout, Freq_Cum = cumsum(Freq), freq_relative = prop.table(Freq))
xout

boxplot(x,horizontal=T,col="grey",xlab="Pourcentage")

qqnorm(x,col="blue")
qqline(x,col="red")

m=mean(x)
md=median(x)
v=var(x)
s=sd(x)
cv=s/m
cat('moyenne =',m,'médiane =',md,', écart-type = ', s,',  variance = ', v ,'\n',
   'coefficient de variation = ', cv )

summary(x)

quantile(x, .5) # la médiane

quantile(x, c(.25,.5,.75)) # pour les 3 quartiles

IQR(x)

mem <-read.csv2("Memoire.csv") # les données sont lues du fichier et placées dans la base 'mem'
# si la commande ne focntionne pas, essayer celle-ci
# mem <- read.csv("Memoire.csv", header = TRUE, sep = ";",dec = ".")

str(mem) # cette commande permet d'avoir un aperçu du nombre d'observations, du nombre et de l'ensemble 
 # des variablesd'une base de données, e.g. ici, 'mem', 
 # avec leur type, 'factor' pour catégoriciel, 'int' pour entier, 'num' pour continue, etc.

mem # on peut voir les données elles-mêmes avec le nom de la base de données

y <- mem$stress # on peut utiliser un nom de variable plus court

y

summary(y)

mean(y)

sd(y)

quantile(y,c(.05,.95))

qqnorm(y)
qqline(y)

by(mem$stress, mem$sexe, function(x) mean(x)) # calcul de la moyenne selon 'sexe'

by(y, mem$sexe, function(x) {mean(x)}) # autre façon de calculer la moyenne selon 'sexe'

by(y, mem$sexe, function(x) var(x)) # calcul de la variance selon 'sexe'

web <- read.csv2("Sites_web.csv")
# si la commande ne focntionne pas, essayer celle-ci
# web <- read.csv(Sites_web.csv", header = TRUE, sep = ";",dec = ".")

str(web)

web

# ceci n'est pas nécessaire :
# attribuons de noms plus courts aux variables de la base de données
v1 <- web$no
v2 <- web$nbre.de.sites.livres
v3 <- web$carnet.de.commandes
v4 <- web$no.equipe
v5 <- web$experience.de.l.equipe
v6 <- web$processus.modifie
v7 <- web$annee
v8 <- web$trimestre

summary(v2)
s2<-sd(v2)
cv2<-sd(v2)/mean(v2)
cat('moyenne =',mean(v2),', médiane =',median(v2),', écart-type = ', s2,
   ', coefficient de variation = ', cv2 )

summary(v3)
s3<-sd(v3)
cv3<-sd(v3)/mean(v3)
cat('moyenne =',mean(v3),', médiane =',median(v3),', écart-type = ', s3,
   ', coefficient de variation = ', cv3 )

layout(matrix(1:2,1,2)) # ceci permet de diviser la sortie graphique en 2
plot(v2[v4==1],v3[v4==1],main="Équipe 1",col="green",lwd=2,
     xlab="Nombre de commandes",ylab="Nombre de sites")
plot(v2[v4==2],v3[v4==2],main="Équipe 2",col="blue", lwd=2,
     xlab="Nombre de commandes",ylab="Nombre de sites")

layout(matrix(1:2,1,2)) # ceci permet de diviser la sortie graphique en 2
plot(v2[v4==1],v5[v4==1],main="Équipe 1",col="green",lwd=2,
     xlab="Nombre de commandes",ylab="Expérience")
plot(v2[v4==2],v5[v4==2],main="Équipe 2",col="blue", lwd=2,
     xlab="Nombre de commandes",ylab="Expérience")

qqnorm(v2)
qqline(v2)

summary(v2[v6==0])
sd(v2[v6==0])

summary(v2[v6==1])
sd(v2[v6==1])

boxplot(v2~v6,col="red")

boxplot(v3~v6,col="yellow")
