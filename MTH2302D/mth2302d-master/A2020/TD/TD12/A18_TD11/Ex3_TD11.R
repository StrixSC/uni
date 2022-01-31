
#                        TD 11 MTH2302C



#                          Exercice 3



# a)  Observations:


# Données
X=c(14,18,40,43,45,112)
Y=c(280,350,470,500,560,1200)

# Tracer le nuage de points
plot(X,Y) #Est-ce qu'un modèle linéaire est plausible ?

#-----------------------------------------------------------------------------------
# Nombre de mesures
n = length(X)
n

# Moyennes échantillonnales
x_bar = mean(X)
x_bar

y_bar = mean(Y)
y_bar

# Somme des carrés corrigée
S_xx = sum((X-x_bar)^2)
S_xx

S_yy = sum((Y-y_bar)^2)
S_yy

# Somme des produits croisés corrigée
S_xy = sum( (X-x_bar) * (Y-y_bar))
S_xy

#========================================================================================

# b) Régression linéaire simple:

# Ajuster un modèle de régression avec la fonction lm
linModel <- lm(Y~ X)

# afficher les resultats numeriques
summary(linModel) 

anova(linModel)

#----------------------------------------------------------------------------------------

# 1. Coefficients de régression

# Calcul des coefficients de régression
beta1_hat = (S_xy / S_xx)
beta0_hat= y_bar - beta1_hat* x_bar

cat('beta0_hat =', beta0_hat, '\n')
cat('beta1_hat =', beta1_hat, '\n')

#--------------------------------------------------------------------------------------

# Tracer la droite de régression
Y_hat = beta0_hat + beta1_hat * X

plot(X,Y, col = 'red', lwd = 2) #données expérimentales (points rouges)
lines(X,Y_hat,col='blue',lwd = 2) #droite des moindres carrés (en bleu)
#--------------------------------------------------------------------------------------

# Estimation de sigma^2

SST = S_yy
#SSE = sum( (Y-Y_hat)^2) #method 1
SSR = sum( (Y_hat-y_bar)^2)
SSE = SST - SSR #method 2

MSR = SSR / 1
MSE = SSE / (n-2)

# Estimateur de l'écart-type des résidus
sigma_hat = sqrt(MSE)
cat('sigma_hat =', sigma_hat)

#---------------------------------------------------------------------------------------

# Ecart-type des coefficients de regression
S_beta0 = sqrt(MSE * (1/n + x_bar^2 / S_xx))
S_beta1 = sqrt(MSE / S_xx)

cat('S(beta0_hat) =', S_beta0, '\n')
cat('S(beta1_hat) =', S_beta1, '\n')

#---------------------------------------------------------------------------------------

# Coefficient de détermination
R = sqrt(SSR / SST)
cat('R^2 =',R^2,'\n')   # On trouve R² = 0.9897179 donc 98.97% de la variabilité totale
                        # est expliquée par le modèle.


#----------------------------------------------------------------------------------------

# 2. Table d'analyse de la variance

cat('Table d\'analyse de la variance : \n')
cat('VAR \t| SS \t\t| df \t| MS \t\t| F0 \t\t| p-value \n')
cat('-----------------------------------------------------------------------------\n')
cat('Reg \t|', SSR, '\t|', 1, '\t|', MSR, '\t|', MSR / MSE, '\t|', pf(MSR/MSE,1,n-2,lower.tail = FALSE),'\n')
cat('Res \t|', SSE, '\t|', n-2, '\t|', MSE, '\t| NA \t\t| NA \n')
cat('Tot \t|', SST, '\t|', n-1, '\t| NA \t\t| NA \t\t| NA \n')

#========================================================================================

# c) Intervalle de confiance pour la pente de la droite de régression

# Intervalle de confiance à 95% pour beta1
alpha = 0.05

l = beta1_hat - qt(alpha/2,n-2,lower.tail=FALSE) * S_beta1    # ou qt(1-alpha/2, n-2)
u = beta1_hat + qt(alpha/2,n-2,lower.tail=FALSE) * S_beta1
cat(l,u)

#==========================================================================================

# d) Test de signification

# 1. Test de Student


# Paramètre du test
beta1_0 = 0
alpha = 0.05

# Statistique de test
t_0 = (beta1_hat - beta1_0) / (sqrt(MSE / S_xx)) #suit une loi t(n-2)

# Région critique
U = qt(alpha/2,n-2,lower.tail = FALSE)            # t_alpha/2;n-2
cat('t0 =',t_0, '\nU = ', U,'\n')

# Conclusion ?      # Ho rejetée  car |t_0| > U = t_alpha/2;n-2 => Modèle significatif
         # Autres façons:
    # façon 1: Calcul de la p-value
    p = 2* pt(t_0,n-2,lower.tail = FALSE)
    cat('p-value =', p,'\n')        # p-value très petite (que alpha): Ho rejetée
    # façon 2: Utiliser la p-value donnée par anova (test de fisher) = P(F>=f_0), voir ci-dessous
    
#--------------------------------------------------------------------------------------------

# 2. Test de Fisher

# Paramètre du test
alpha = 0.05

# Statistique de test
f_0 = MSR / MSE #suit une loi F(1,n-2)

# Région critique
U = qf(alpha,1,n-2,lower.tail = FALSE)    # F_alpha;1,n-2 
cat('f0 =',f_0, '\n U = ', U,'\n')

# Conclusion ?          # f_0 > U = F_alpha;1,n-2 donc Ho est rejetée => Modèle significatif

# Calcul de la p-value
p = pf(f_0,1,n-2,lower.tail = FALSE)
cat('p-value =', p,'\n')


#===========================================================================================

# e) Analyse des résidus

# 1. Calcul des résidus ; étude de la variabilité

# Calcul des résidus
res = Y - Y_hat

# Variabilité autour de la droite
plot(Y_hat, res, lwd = 2)

#-------------------------------------------------------------------------------------------

# 2. Test de normalité


# Test de normalité des résidus
shapiro.test(res)

# Graphique quantile-quantile des résidus
qqnorm(res)
qqline(res)

# Conclusion ?


#===============================================================================================

# f) Intervalle de confiance pour la valeur moyenne en  x0


# Intervalle de confiance pour la droite de régression en x0=145
alpha= 0.05
x0 = 145

y0_hat = beta0_hat + beta1_hat * x0

# Calcul des bornes de l'intervalle
l =y0_hat - qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1/n + (x0 - x_bar)^2 / S_xx))
u =y0_hat + qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1/n + (x0 - x_bar)^2 / S_xx))
cat(l, u)

# N.B: Remplacer 1/n par 1+1/n dans les formules ci-dessus pour obtenir l'intervalle de 
# prévision en x0

#-----------------------------------------------------------------------------------------------

# Tracer les intervalles de confiance
x_prev = seq(min(X),max(X),by=(max(X)-min(X))/(2 * n))
y_prev = beta0_hat + beta1_hat * x_prev

l_prev =y_prev - qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1/n + (x_prev - x_bar)^2 / S_xx))
u_prev =y_prev + qt(alpha/2,n-2,lower.tail=FALSE) * sqrt(MSE * (1/n + (x_prev - x_bar)^2 / S_xx))

plot(X,Y, lwd = 2)        #(ou simplement plot(X,Y)), Diagramme de dispersion

# Droite des moindres carrés (en bleu)
lines(X,Y_hat,col='blue', lwd = 2)
# Intervalles de confiance (en rouge)
lines(x_prev,l_prev,lty=2,col='red')
lines(x_prev,u_prev,lty=2,col='red')

