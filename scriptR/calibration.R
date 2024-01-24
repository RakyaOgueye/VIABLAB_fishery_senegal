#install.packages("deSolve")
library(deSolve)
rm(list = ls())


# 1. Simulation du Modèle
# 
# Commencez par simuler le modèle avec vos valeurs initiales de paramètres pour 
# voir comment le système se comporte. Cela vous donnera une idée de base de 
# l'état d'équilibre (ou de non-équilibre) du système avec les paramètres initiaux.



#Définition des équations différentielles
model <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    dBdt = r * B * (1 - B/k) - q * a * n * B
    dCdt = alpha * (q * a * n * B - lambda * n - gamma * C)
    
    return(list(c(dBdt, dCdt)))
  })
}

#Paramètres initiaux et conditions initiales 
## B       = Biomass initial dans le lac
## C       = capital des pecheurs
### r      = Taux de croissance annuel == https://horizon.documentation.ird.fr/exl-doc/pleins_textes/divers10-10/03839.pdf
### k      = Capacité de charge max
### q      = proba d'attrapé des poisson (symbolise la difficulté)
### a      = accessibilité du lac (qui tend vers zero avec les réserve et le typha)
### n      = le nombre de sortie par ans de pirogue
### alpha  = le prix du poisson par tones
### lambda = le cout de production d'une pirogue
### gamma  = la dépréciation du capitale

B_initial <- 30000 #Biomass initial dans le lac
C_initial <- 2000000 #capital des pecheurs

r_value <- 0.98     # Taux de croissance annuel
r_min <- 0
r_max <- 1

k_value <- 100000   # Capacité de charge max

q_value <- 0.001    # proba d'attrapé des poisson
q_min <- 0
q_max  <- 1

a_value <- 0.8      #accessibilité du lac
a_min <- 0
a_max <- 1

n_value <- 2000
n_min <- 200
n_max <- 5000

alpha_value <- 1500000
alpha_min <- 1000000
alpha_max <- 3000000

lambda_value <- 542025

gamma_value <- 0.002
gamma_min <- 0
gamma_max <- 1

# Définir les bornes inférieures et supérieures pour chaque paramètre
lower_bounds <- c(r_min,q_min, a_min, n_min, alpha_min, gamma_min)
upper_bounds <- c(r_max, q_max, a_max, n_max, alpha_max, gamma_max)

initial_state <- c(B = B_initial, C = C_initial)
parameters <- c(r = r_value, k = k_value, q = q_value, a = a_value, 
                n = n_value, alpha = alpha_value, 
                lambda = lambda_value, gamma = gamma_value)
times <- seq(0, 100, by = 1)  # Ajustez selon le besoin


out <- ode(y = initial_state, times = times, func = model, parms = parameters)
simulated_data <- as.data.frame(out)
plot(simulated_data$time, simulated_data$B, type = 'l', xlab = "Temps", ylab = "Biomasse")

# 2. Analyse de Sensibilité
# 
# Effectuez une analyse de sensibilité pour comprendre l'impact de chaque paramètre
# sur la biomasse B. Cela implique de faire varier chaque paramètre dans sa plage
# (par exemple, de r_min à r_max) et d'observer comment cela affecte la biomasse 
# au fil du temps. Cela vous aidera à identifier quels paramètres sont cruciaux 
# pour maintenir la biomasse au-dessus de zéro.

## tres brut force 
# Paramètres initiaux et conditions initiales
initial_state <- c(B = 30000, C = 2000000)
times <- seq(0, 100, by = 1)

# Grille de paramètres (exemple simple)
r_values <- seq(0.8, 1, by = 0.1)
q_values <- seq(0.001, 0.01, by = 0.001)
n_value <- seq(500, 5000, by = 500)

# Stockage des résultats
results <- list()
# DataFrame pour stocker les résultats
results_df <- data.frame()

# Simulation pour chaque combinaison de r et q
for (r in r_values) {
  for (q in q_values) {
    for (n in n_value){
      
    parameters <- c(r = r, k = 100000, q = q, a = 0.8, n = n_value, 
                    alpha = 1500000, lambda = 542025, gamma = 0.002)
    out <- ode(y = initial_state, times = times, func = model, parms = parameters)
    simulated_data <- as.data.frame(out)
    
    # Vérifier si B tombe à zéro
    if (all(simulated_data$B > 1000)) {
      results[[paste("r=", r, "q=", q, "n=",n)]] <- simulated_data
      results_df <- rbind(results_df, c(r, q, n, simulated_data$B[101]))
    }
  }
  }
}

colnames(results_df) <- c("r","q","n","biomass")
results_df <- results_df[order(-results_df$biomass), ]

# Visualisation des scénarios réussis
for (scenario in names(results)) {
  plot(results[[scenario]]$time, 
       results[[scenario]]$B, 
       type = 'l', 
       xlab = "Temps", ylab = "Biomasse",
       ylim = c(0,100000),
       main = scenario)
}

# 3. Recherche de l'Équilibre
# 
# Utilisez une méthode d'exploration de l'espace des paramètres (comme une grille 
# de recherche ou un algorithme d'optimisation si nécessaire) pour trouver des 
# combinaisons de paramètres qui conduisent à un état d'équilibre souhaitable. 
# Vous pouvez définir une fonction de coût (ou objectif) qui mesure à quel point 
# la biomasse est éloignée de zéro et tenter de la minimiser.

# 4. Visualisation
# 
# Visualisez les résultats des simulations pour différentes combinaisons de paramètres.
#Cela peut impliquer la création de graphiques montrant la biomasse au fil du temps 
#pour différentes valeurs de paramètres, ou des diagrammes de phase montrant l'état 
# d'équilibre en fonction des paramètres.









#########################

cost_function <- function(parameters) {
  # Ajuster les paramètres du modèle
  names(parameters) <- c("r", "k", "q", "a", "n", "alpha", "lambda", "gamma")
  
  # Simuler le modèle
  out <- ode(y = initial_state, times = times, func = model, parms = parameters, atol = 1e-3, rtol = 1e-3)
  simulated_data <- as.data.frame(out)
  
  # Pénaliser si la biomasse ou le capital tombe en dessous de zéro
  cost = sum(simulated_data$B < 0) * 1000 + sum(simulated_data$C < 0) * 1000
  
  return(cost)
}


initial_parameters <- c(r = r_value, k = k_value, q = q_value, a = a_value, 
                        n = n_value, alpha = alpha_value, 
                        lambda = lambda_value, gamma = gamma_value)

optim(par = initial_parameters, fn = cost_function, method = "L-BFGS-B", 
      lower = lower_bounds, upper = upper_bounds) #L-BFGS-B ou Nelder-Mead


