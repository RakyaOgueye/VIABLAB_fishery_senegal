## R copilot for viablal

# Installer et charger le package nécessaire
if (!require("rjson")) install.packages("rjson")
library(rjson)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


##Les parametres a modifier dans le fichier source/data
Rr <-0.015;
Ra <- 0.8;      #// accessibilité
Rk <-100000;    #//tonne
REmax <- 30000; #// tonne/pirogue/an 
Rc <- 6.935;    #// capture en tonne/an/pirogue
Rlambda <-987000; #// coût en cfa de sortie par pirogue par an
Rg <- 0.1;      #// proportion du capital perdue dû à l'inflation

## les parametres a modifier dans le fichier INPUT/*.json
prefix_json <- "model2D1-pouf"
control_dim_json <- 2
control_min_val_json <- c(0,0)
control_max_val_json <- c(2988,1065)


## Modifier les parametres d'entrer ####
# Lire le fichier
fichier <- "../source/data/model_economique.h"
contenu <- readLines(fichier)

# Vérifier si le fichier a assez de lignes
if (length(contenu) >= 45) {
  # Modifier les lignes 43, 44 et 45
  nouvelles_lignes <- c(
    paste0("double r=",Rr,";"),
    paste0("double a=",Ra,";"),
    paste0("double k=",Rk,";"),
    paste0("double Emax=",REmax,";"),
    paste0("double c=",Rc,";"),
    paste0("double lambda=",Rlambda,";"),
    paste0("double g=",Rg,";")
  )
  contenu[39:45] <- nouvelles_lignes
  
  # Réécrire le fichier
  writeLines(contenu, fichier)
} else {
  print("Le fichier n'a pas assez de lignes pour être modifié.")
}

## Modifier les INPUT ####
fichier <- "../INPUT/test.json"
donnees <- fromJSON(file = fichier)

# Modifier les valeurs

donnees$CONTROL_PARAMETERS$CONTROL_DIMENSION <- control_dim_json
donnees$CONTROL_PARAMETERS$CONTROL_MIN_VALUES <- control_min_val_json
donnees$CONTROL_PARAMETERS$CONTROL_MAX_VALUES <- control_max_val_json
donnees$GRID_PARAMETERS$OUTPUT_FILE_PREFIX <- prefix_json

# Réécrire le fichier JSON avec les nouvelles valeurs
write(toJSON(donnees), file = fichier)


## Recompiler et faire tourner le modele ####

# Changer de répertoire
setwd("../source/")

system("make clean")

# Compiler le code C++ avec make
system("make")

# Exécuter le fichier exécutable
system("./viabLabExe")
