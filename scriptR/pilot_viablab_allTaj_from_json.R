## R copilot for viablal
rm(list = ls())
# Installer et charger le package nécessaire
if (!require("rjson")) install.packages("rjson")
library(rjson)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Lire le fichier JSON
donnees <- fromJSON(file = "../INPUT/model_FL_trajectoires.json")
# lire le fichier de noyau
ny <- read.csv("../OUTPUT/model_FL_traj2-viab-0.dat", sep = " ")
ny <- ny[,1:2]
colnames(ny) <- c("biomass","capital")

for(i in 1:length(ny[,1])){
  # Modifier les valeurs
  nouvelles_valeurs_init <- c(ny$biomass[i], ny$capital[i]) # Remplacer par vos nouvelles valeurs min
  donnees$ALGORITHM_PARAMETERS$INITIAL_POINTS$POINT$POINT_COORDINATES <- nouvelles_valeurs_init
  donnees$GRID_PARAMETERS$OUTPUT_FILE_PREFIX <-paste0("model_alltraj",i)
  
  
  # Réécrire le fichier JSON avec les nouvelles valeurs
  # write(toJSON(donnees), file = "/tmp/a_test1.json")
  write(toJSON(donnees), file = "../INPUT/model_FL_trajectoires.json")
  
  
  
  # Changer de répertoire
  setwd("../source/")
  
  # Compiler le code C++ avec make
  #system("make clean")
  #system("make")
  
  # Exécuter le fichier exécutable
  system("./viabLabExe")
}


