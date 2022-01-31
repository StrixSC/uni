# Tutoriel pour R
# Les commandes ci-dessous peuvent être exécutées dans R ou Rstudio
Notes <- read.csv("Notes.csv", header = TRUE, sep = ";",dec = ".")
Notes
hist(Notes$STATS)
hist(Notes$STATS, col="grey",border="magenta", main=paste("Feminin"),
     xlab="Notes de stats",ylab="Fréquences")
layout(matrix(1:2,1,2)) # permet de diviser la sortie graphique en deux
hist(Notes$STATS[Notes$SEXE=="F"], col="yellow",border="cyan", 
     main=paste("Feminin"),xlab="Notes de stats",ylab="Fréquences")
hist(Notes$STATS[Notes$SEXE=="M"], col="green",border="red", 
     main=paste("Masculin"),xlab="Notes de stats",ylab="Fréquences")

hist(Notes$STATS, col="grey",border="magenta", main=paste("Feminin"),
     xlab="Notes de stats",ylab="Fréquences", freq=FALSE)
lines(density(Notes$STATS), lwd=2) # densité ajustée
x = seq(5,21,length.out=500) 
lines(x, dnorm(x, mean(Notes$STATS), sd(Notes$STATS)), lwd=2, lty=3) 
#densité d'une loi normale
boxplot(Notes$STATS)
boxplot(STATS~GROUP, data=Notes)
boxplot(Notes$STATS~Notes$GROUP,
col=c("lightpink","lightblue"),
horizontal=TRUE,
notch=TRUE,
main=paste("Notes de stats de",nrow(Notes),"étudiants"),
ylab="Groupe",
las=1)


qqnorm(Notes$STATS)
qqline(Notes$STATS, col="red", lwd=2)

layout(matrix(1:2,1,2)) #divise la sortie graphique en deux
# groupe A
qqnorm(Notes$STATS[Notes$GROUP=="A"], main="groupe A")
qqline(Notes$STATS[Notes$GROUP=="A"], col="red", lwd=2)

# groupe B
qqnorm(Notes$STATS[Notes$GROUP=="B"], main="groupe B")
qqline(Notes$STATS[Notes$GROUP=="B"], col="red", lwd=2)

plot(Notes$STATS, Notes$ECONO, xlab = "notes stats", 
     ylab = "notes éco", main="nuage de points")

plot(Notes$STATS, Notes$ECONO, xlab = "notes stats", 
     ylab = "notes éco", main="nuage de points",lwd=3, col=Notes$SEXE)



cor(Notes$STATS, Notes$ECONO)

mesures = data.frame(notes=c("ECONO", "STATS"), 
                     moyenne=NA, s=NA, q1=NA, mediane=NA,
                     q3=NA, r=NA, iqr=NA, min=NA, max=NA,
                     kurt=NA, skew=NA)
mesures

#moyenne
mesures$moyenne = sapply(2:3, function(i) mean(Notes[,i]))
mesures

# écart-type
mesures$s = sapply(2:3, function(i) sd(Notes[,i]))
# mediane
mesures$mediane = sapply(2:3, function(i) sd(Notes[,i]))
# min
mesures$min = sapply(2:3, function(i) min(Notes[,i]))
# max
mesures$max = sapply(2:3, function(i) max(Notes[,i]))
# quantiles q1 et q3
mesures[1, c("q1", "q3")] = quantile(Notes$ECONO, probs = c(0.25,0.75))
mesures[2, c("q1", "q3")] = quantile(Notes$STATS, probs = c(0.25,0.75))
# étendue
mesures$r = mesures$max - mesures$min
mesures$iqr = mesures$q3 - mesures$q1
options(digits=4) # Pour limiter le nombre de décimales et 
mesures

#install.packages("moments")

library(moments)
# si la commande échoue, on installe alors le package
#install.packages("moments") dans la ligne de commande qui précède
# enlever la dièse pour l'exécution!
# et on réexécute la commande library

# asymétrie (skewness)
mesures$skew = sapply(2:3, function(i) skewness(Notes[,i]))
    
# aplatissment (kurtosis)
mesures$kurt = sapply(2:3, function(i) kurtosis(Notes[,i])) - 3
# On fait -3 pour être conforme à la formule du cours
options(digits=4) 
mesures



x = rnorm(n = 1000, mean = 10, sd = 2)
hist(x, freq=F, col="skyblue")
lines(density(x), col="red", lwd=2)



1- pnorm(12.5, 10, 3)
# ou
pnorm(12.5, 10, 3, lower.tail = F)

# possibilité 1 : P(X>x_0.05) = 0.05 ==> P(X <= x_0.05) = 0.95
qnorm(0.95, 10, 3)

# possibilité 2 : lower.tail = F
qnorm(0.05, 10, 3, lower.tail = F)



reg<-lm(Notes$STATS~Notes$ECONO)

summary(reg)

anova(reg)

plot(reg)



reg2<-lm(STATS~ECONO, data=Notes)



summary(reg2)

?plot()
