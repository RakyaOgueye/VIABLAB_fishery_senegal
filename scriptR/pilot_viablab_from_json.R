## R copilot for viablal

# Installer et charger le package nécessaire
if (!require("rjson")) install.packages("rjson")
library(rjson)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Lire le fichier JSON
donnees <- fromJSON(file = "../INPUT/model_economique.json")

# Modifier les valeurs
nouvelles_valeurs_min <- c(12345, 67890) # Remplacer par vos nouvelles valeurs min
nouvelles_valeurs_max <- c(23456, 78901) # Remplacer par vos nouvelles valeurs max
donnees$CONTROL_PARAMETERS$CONTROL_MIN_VALUES <- nouvelles_valeurs_min
donnees$CONTROL_PARAMETERS$CONTROL_MAX_VALUES <- nouvelles_valeurs_max

# Réécrire le fichier JSON avec les nouvelles valeurs
write(toJSON(donnees), file = "/tmp/test.json")


# Changer de répertoire
setwd("../source/")

# Compiler le code C++ avec make
system("make .")
system("make .")

# Exécuter le fichier exécutable
system("./viabLabExe")

