# Chargez la bibliothèque tidyverse, qui inclut ggplot2 et d'autres paquets utiles
library(tidyverse)

# Définissez le répertoire de travail au répertoire contenant le fichier en cours dans RStudio
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Lire le fichier de données bound2 depuis le chemin spécifié
# Ce fichier contient des colonnes sans en-tête initialement
bound2 <- read.table("../OUTPUT/francois_2D_traj--viab-0.dat", header = F)
# Renommer les colonnes du dataframe bound2
colnames(bound2) <- c("biomass", "capital", "z")

traj1 <- read.table("../OUTPUT/francois_2D_traj--traj-1.dat", header = F)
colnames(traj1) <- c("biomass", "capital", "z", "nbSortie", "prixVente")

traj2 <- read.table("../OUTPUT/francois_2D_traj--traj-2.dat", header = F)
colnames(traj2) <- c("biomass", "capital", "z", "nbSortie", "prixVente")

# Créer un graphique avec ggplot
ggplot() +
  # Optionnellement, on pourrait ajouter des tuiles représentant le bound2
  geom_tile(data = bound2, aes(x = biomass, y = capital), fill = "lightblue") +
  
  # Ajouter les points de traj1 au graphique, en colorant par nbSortie et ajustant la taille par prixVente
  geom_point(data = traj1, aes(x = biomass, y = capital, colour = nbSortie, size = prixVente)) +
  
  # Ajouter les points de traj2 au graphique, avec la même esthétique que traj1
  geom_point(data = traj2, aes(x = biomass, y = capital, colour = nbSortie, size = prixVente)) +
  
  scale_color_gradient(low = "#D2B48C", high = "#8B4513") +
  
  # Ajouter une ligne horizontale au niveau de y = 34252025
  geom_hline(yintercept = 34252025, color = "black") +
  
  # Ajouter une ligne verticale au niveau de x = 1000
  geom_vline(xintercept = 1000, color = "black") +
  
  # Ajouter un titre au graphique
  labs(title = "Noyau de viabilité") +
  
  # Appliquer le thème graphique "bw" (blanc et noir) pour un look propre et minimaliste
  theme_bw()
