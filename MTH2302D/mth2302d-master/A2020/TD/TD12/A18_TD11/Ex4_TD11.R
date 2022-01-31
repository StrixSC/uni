
#                        TD 11 MTH2302C



#                          Exercice 4

# Observations:

#Données

X1=c(30,30,30,30,50,50,50,50,70,70,70,70,90,90,90,90)
Y=c(66.83,72.77,68.04,66.11,84.45,83.06,77.92,84.00,93.94,86.71,92.38,87.60,86.27,90.19,88.97,84.95)

# Tracer le nuage de points
plot(X1,Y, lwd = 2)

#---------------------------------------------------------------------------------------------------

# Nombre de mesures
n = length(X1)

# Moyennes échantillonnales
x_bar = mean(X1)
y_bar = mean(Y)

# Somme des carrés corrigée
S_xx = sum((X1-x_bar)^2)
S_yy = sum((Y-y_bar)^2)
# Somme des produits croisés corrigée
S_xy = sum( (X1-x_bar) * (Y-y_bar))

#===================================================================================================

# a) Régression linéaire simple

# Régression linéaire avec lm
linReg = lm(Y~X1)
summary(linReg)

beta_hat = unname(coefficients(linReg))             # beta_0            beta_1
beta_hat

S_beta = unname(summary(linReg)$coefficients[,2])   # sd(beta_0)        sd(beta_1)
S_beta

beta1_hat = beta_hat[2]      # beta_1
beta1_hat

beta0_hat = beta_hat[1]      # beta_0
beta0_hat
#---------------------------------------------------------------------------------------------------

# Tableau d'analyse de la variance

anova(linReg)

# On peut observer dans le tableau (dans la colonne "Sum"): 

SS_R = beta1_hat * S_xy    # Somme des carrés due à la régression
SS_R

SS_E = S_yy - SS_R         # Somme des carrés due à l'erreur
SS_E

#===================================================================================================

# b) Analyse des résidus

par(mfrow=c(2,2))
Y_hat= fitted.values(linReg)
Y_hat

# Calcul des résidus
res=residuals(linReg)
res

plot(linReg)
#---------------------------------------------------------------------------------------------------

# Test de normalité
shapiro.test(res)

# Conclusion ?

#---------------------------------------------------------------------------------------------------

# 1.c) Test de signification du modèle

summary(linReg)

#---------------------------------------------------------------------------------------------------

# 2.c) Intervalle de confiance pour la pente de la droite de régression

# Intervalle de confiance à 95% pour beta1
confint(linReg,parm='X1',level = 0.95)
confint(linReg,level = 0.95)           # Affiche les I.C pour beta_0 puis beta_1
confint(linReg,parm='(Intercept)',level = 0.95)  # I.C pour beta_0
#====================================================================================================

# d) Intervalle de prévision

# Intervalle de prévision à 95% pour y en x=60
alpha= 0.05
x0 = 60
y0_hat = beta_hat[1] + beta_hat[2] * x0

MSE = sum(residuals(linReg)^2) / (n-2)
l =y0_hat - qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1+1/n + (x0 - x_bar)^2 / S_xx))
u =y0_hat + qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1+1/n + (x0 - x_bar)^2 / S_xx))
cat(l, u)

#----------------------------------------------------------------------------------------------------

# Tracer les intervalles de prévision à 95%
alpha = 0.05

x_prev = seq(min(X1),max(X1),by=(max(X1)-min(X1))/20)
y_prev = beta_hat[1] + beta_hat[2] * x_prev

MSE = sum(residuals(linReg)^2) / (n-2)
l_prev =y_prev - qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1+1/n + (x_prev - x_bar)^2 / S_xx))
u_prev =y_prev + qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1+1/n + (x_prev - x_bar)^2 / S_xx))

par(mfcol=c(1,1)) 
plot(X1,Y)
lines(X1,fitted.values(linReg),col='blue')
lines(x_prev,l_prev,lty=2,col='red')
lines(x_prev,u_prev,lty=2,col='red')


#remove(x_prev,y_prev,l_prev,u_prev)
#====================================================================================================

# e) Régression polynomiale du second degré

# 1. Mise en forme des données

X0 = rep(1,n)
X2 = X1^2
k=2

# Formation de la matrice X
X = matrix(c(X0,X1,X2), nrow = n,ncol = 3)   # Matrice X, page 16 du cours sur la régression multiple
C = solve( t(X) %*% X)     # t(X) représente la transposée du vecteur X
                           # t(X) %*% X pour effectuer le produit matriciel de t(X) et X
                           # solve(A) calcul l'inverse de A. 

# Vérifier que 
C %*% (t(X) %*% X)   # donne bien la matrice identité.
# ou arrondir avec round:
round(C %*% (t(X) %*% X))

#----------------------------------------------------------------------------------------------------

# 2. Ajustement du modèle de régression

# Régression avec lm
qReg = lm(Y ~ X1+X2)  #  On peut remplacer X2 par I(X1*X1)
summary(qReg)

# Coefficients de régression et leurs écart-types echantillonaux
beta_hat = unname(coefficients(qReg))

S_beta = unname(summary(qReg)$coefficients[,2])

cat('beta_hat =', beta_hat, '\n')
cat('S_beta =', S_beta)

#----------------------------------------------------------------------------------------------------

# 3. Courbe de régression

# valeurs de la régression
Y_hat = fitted.values(qReg)
Y_hat

# Courbe de regression
plot(X1,Y)

x_reg = seq(min(X1),max(X1),by = 3)
y_reg = beta_hat[1] + beta_hat[2] * x_reg + beta_hat[3] * x_reg^2
lines(x_reg,y_reg,col='blue',lwd=2)

#remove(x_reg)
#remove(y_reg)

#-------------------------------------------------------------------------------------------------

# 4. Table d'analyse de la variance 

anova(qReg)

#=================================================================================================

# f) Test de signification global

summary(qReg)

#=================================================================================================

# g) Comparaison des modèles

summary(linReg)
summary(qReg)

#=================================================================================================

# h) Rendement optimal

beta = unname(coefficients(qReg))

x_opt = -beta[2] / (2*beta[3])
x_opt



