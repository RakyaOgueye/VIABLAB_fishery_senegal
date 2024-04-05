## R copilot for viablal

# Installer et charger le package nécessaire
if (!require("rjson")) install.packages("rjson")
library(rjson)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Valeur fixe pour Rr
Rr <- 0.9
Ra <- 0.8      #// accessibilité
Rk <- 10560   #// tonne
Rlambda <- 987000 #// coût en cfa de sortie par pirogue par an
Rg <- 0.1      #// proportion du capital perdue dû à l'inflation
Rq <- 0.0001    #//capturabilité

# Boucle sur control_min_val_json
for(control_min in seq(from = 0, to = 100, by = 1)){
  control_min_val_json <- c(control_min, 0)
  
  ## Modifier les parametres d'entrer ####
  # Lire le fichier model_economique.h et le modifier
  fichier_h <- "../source/data/model_economique.h"
  contenu_h <- readLines(fichier_h)
  
  if (length(contenu_h) >= 45) {
    nouvelles_lignes_h <- c(
      paste0("double r=", Rr, ";"),
      paste0("double a=", Ra, ";"),
      paste0("double k=", Rk, ";"),
      paste0("double lambda=", Rlambda, ";"),
      paste0("double g=", Rg, ";"),
      paste0("double q=", Rq, ";")
    )
    contenu_h[39:44] <- nouvelles_lignes_h
    writeLines(contenu_h, fichier_h)
  } else {
    print("Le fichier model_economique.h n'a pas assez de lignes pour être modifié.")
  }
  
  # Modifier le fichier model_economique.json
  fichier_json <- "../INPUT/model_economique.json"
  donnees <- fromJSON(file = fichier_json)
  
  donnees$CONTROL_PARAMETERS$CONTROL_DIMENSION <- 2
  donnees$CONTROL_PARAMETERS$CONTROL_MIN_VALUES <- control_min_val_json
  donnees$CONTROL_PARAMETERS$CONTROL_MAX_VALUES <- c(3000, 1500)
  donnees$GRID_PARAMETERS$OUTPUT_FILE_PREFIX <- paste0("model2D-control_min", control_min, "")
  
  write(toJSON(donnees), file = fichier_json)
  
  ## Recompiler et faire tourner le modele ####
  setwd("../source/")
  system("make clean")
  system("make")
  system("./viabLabExe")
}
