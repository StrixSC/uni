

#Setting working directory
setwd("C:/Users/Joe/Documents/University/2019 Automne/MTH230D - Probabilite et Statistique/TP/Partie 2");

#Getting Data
data = read.csv("1939689_1903555_1881786.csv", header = TRUE, 
                col.names = c("id", "name", "nationality", "ppg", 
                              "mpg", "fgm", "fga", "threepm", "rebounds", "assists", "steals", "blocks", "turnovers", "efficiency"));



#Question 1: La nationalité d'un joueur donne-t-elle avantage pour être parmi les élites de la NBA? #
barplot(table(data["nationality"]), main = "Nationalités des 50 meilleurs joueurs");


#Question 2: Est-ce qu'un joueur ayant plus de perte de balle a-t-il toujours moins d'efficacité, existe-t-il une relation entre ses deux variables? #
plot( 
  data$turnovers, 
  data$efficiency, 
  col="blue", 
  main="Le nuage de points", 
  xlab="Perte de balle", 
  ylab="EfficacitÃ©"
); # Creating plot

regLin <- lm(data$efficiency ~ data$turnovers); #Creating regression line
abline(regLin, col="red"); # Adding regression line to plot
summary(regLin); #Display the linear regression's infos

#Question 3: Ce peut-il que l'augmentation des minutes jouées par match diminue l'efficacité d'un joueur ? #

cor.test(data$efficiency, data$mpg, method = "pearson");
cor.test(data$efficiency, data$mpg, method = "pearson", conf.level = 0.9);

shapiro.test(data$efficiency);
shapiro.test(data$mpg);

plot(
  x = data$efficiency, 
  y = data$mpg, 
  main = "Correlation entre minutes jouees et efficacite", 
  xlab = "Efficacite", 
  ylab = "Minutes jouees", 
  xlim = c( min( data$efficiency ) - 1 , max( data$efficiency) + 1 ), 
  ylim = c( min( data$mpg ) - 1, max( data$mpg ) + 1)
); # Creating plot

legend(
  x = "bottomright", 
  legend = paste(
    "Pearson's Correlation =",round(cor(data$efficiency, data$turnovers, method = "pearson"),4),
    "\nSpearman's Rank Correlation = ", round(cor(x=data$efficiency, y=data$turnovers, method = 'spearman'),4)
  )); # Adding Correlations to the plot

abline(lm( data$mpg ~ data$efficiency), col = "red", lwd=2); # Adding regression line to plot

