## read data from VIABLAB
library(ggplot2)


## set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## read data 
### grid_data.dat    => les variables d'état et les valeurs min et max et discretiastion
### viab-0-bound.dat => Tout les point du noyaux (chaque colone est un controle)
### viab-0.dat       => le meme que bound, mais avec le contour
data.df <- read.table("../OUTPUT/model2D--viab-0-bound.dat")

ggplot(data = data.df)+
  geom_point(aes(x = V1, y = V2))
