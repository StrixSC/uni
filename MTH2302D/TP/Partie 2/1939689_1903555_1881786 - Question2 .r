donnees <- read.csv("Travail-Partie-1.csv")
donnees
plot(donnees$TOV,donnees$EFF,col="blue", main="Le nuage de points", xlab="Perte de balle", ylab="Efficacité")
regLin <- lm(donnees$EFF~donnees$TOV)
abline(regLin, col="red")
summary(regLin)