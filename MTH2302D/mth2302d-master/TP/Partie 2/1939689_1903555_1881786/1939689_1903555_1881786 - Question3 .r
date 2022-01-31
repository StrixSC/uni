
# Installing external library
if(!require(ggpubr)) 
  install.packages("ggpubr");

setwd("C:/Users/Joe/Documents/University/2019 Automne/MTH230D - Probabilite et Statistique/TP/Partie 2");

#Getting Data
data = read.csv("1939689_1903555_1881786.csv", header = TRUE, 
                col.names = c("id", "name", "nationality", "ppg", 
                              "mpg", "fgm", "fga", "threepm", "rebounds", "assists", "steals", "blocks", "turnovers", "efficiency"));

# Loading library
library("ggpubr");

# Visual Inspection of the data's normality
ggqqplot(data$mpg, ylab = "Minutes jouees par Match");
ggqqplot(data$efficiency, ylab = "Efficacite");

# Shapiro-Wilk normality test
shapiro.test(data$efficiency);
shapiro.test(data$mpg);

# Corrolations tests
cor.test(data$efficiency, data$mpg, method = "pearson");
cor.test(data$efficiency, data$mpg, method = "pearson", conf.level = 0.9);


# Scatter Plot
ggscatter(
  data, 
  x = data$mpg, 
  y = data$efficiency, 
  add = "reg.line", 
  conf.int = TRUE, 
  cor.method = "pearson", 
  xlab = "Minutes par match", 
  ylab = "Efficacite"
)




