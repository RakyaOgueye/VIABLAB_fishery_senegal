# Charger les bibliothèques nécessaires
library(tidyverse)

# Supprimer toutes les variables de l'environnement de travail
rm(list = ls())

# Définir le répertoire de travail
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Lister les fichiers se terminant par 'traj-1.dat' dans le répertoire ../OUTPUT/
fichiers <- list.files(path = "../OUTPUT/", pattern = "traj-1\\.dat$")

# Initialiser des data frames vides pour stocker les données
all.df <- data.frame()
lastRow.df <- data.frame()

# Boucle pour lire chaque fichier et ajouter les données au data frame
for (i in 1:length(fichiers)) {
  # Lire les données du fichier courant
  df <- read.csv(paste0("../OUTPUT/", fichiers[i]), header = FALSE, sep = "", stringsAsFactors = FALSE)
  # Ajouter une colonne pour identifier la trajectoire
  df$traj <- i
  # Combiner les données du fichier courant avec le data frame principal
  all.df <- rbind(all.df, df)
  # Ajouter la dernière ligne du fichier courant au data frame des dernières lignes
  lastRow.df <- rbind(lastRow.df, tail(df, n = 1))
}

# Écrire les données combinées dans des fichiers CSV
write.csv(all.df, "/tmp/viab_all_traj.csv", row.names = FALSE)
write.csv(lastRow.df, "/tmp/viab_all_traj_lastRow.csv", row.names = FALSE)

# Compter les occurrences des couples (V1, V2)
counts <- all.df %>%
  group_by(V1, V2) %>%
  summarise(count = n(), .groups = "drop") %>%
  as.data.frame()

# Renommer les colonnes du data frame counts
colnames(counts) <- c("biomass", "capital", "occurrence")

# Créer la heatmap hexagonale avec ggplot2
ggplot() +
  # Ajouter les hexagones représentant la densité de points
  geom_hex(data = counts, aes(x = biomass, y = capital, fill = occurrence), bins = 50) +
  # Ajouter les points représentant les dernières lignes des trajectoires
  geom_point(data = lastRow.df, aes(x = V1, y = V2), alpha = 0.2) +
  # Définir le gradient de couleur pour la densité
  scale_fill_gradient(low = "#fee0d2", high = "#de2d26") +
  # Ajouter les labels et le titre
  labs(title = "Densité de point de toutes les trajectoires viables", 
       fill = "Nombre\nde points\npar unité\nde surface",
       x = "Biomasse", y = "Capital") +
  # Appliquer un thème minimaliste
  theme_bw()

