## un script qui valire tour a tour les résultats produit par Viablab et qui va crée 
## une graph qui représente le noyaux de viabilité calucler en fonction de la variable "r"

library("ggplot2")

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

l.file 


# Définir le chemin du dossier contenant les fichiers .dat
chemin_dossier <- "../OUTPUT/"

## read data 
### grid_data.dat    => les variables d'état et les valeurs min et max et discretiastion
### viab-0-bound.dat => Tout les point du noyaux (chaque colone est un controle)
### viab-0.dat       => le meme que bound, mais avec le contour

# Filtrer les fichiers qui contiennent '-r' dans leur nom
fichiers_initiaux <- list.files(path = chemin_dossier, pattern = "-r.*\\.dat$", full.names = TRUE)

# Exclure les fichiers qui contiennent 'grid' ou 'bound'
fichiers_filtres <- fichiers_initiaux[!grepl("grid|bound", fichiers_initiaux)]

# Extraire la partie du nom de fichier après 'r' et avant le prochain '-' ou '_'
valeurs_apres_r <- stringr::str_extract(fichiers_filtres, "(?<=r)[^_-]+")


# Initialiser la barre de progression
pb <- txtProgressBar(min = 0, max = length(fichiers_filtres), style = 3)

for(i in 1:length(fichiers_filtres)){
  # Mise à jour de la barre de progression
  setTxtProgressBar(pb, i)
  
  data.df <- read.table(fichiers_filtres[i])
  colnames(data.df) <- c("x", "y", "value")
  
  
  ggplot(data = data.df)+
    geom_point(aes(x = x, y = y, color = value))+
    labs(title = paste0("r =", valeurs_apres_r[i]))
  
  suppressMessages(ggsave(paste0("/tmp/ggR/ggviab",valeurs_apres_r[i],".png"), width = 9))
  
}

# Fermer la barre de progression
close(pb)
