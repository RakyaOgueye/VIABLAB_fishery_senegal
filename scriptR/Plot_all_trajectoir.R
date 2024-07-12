
library(tidyverse)


rm(list = ls())

## set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Lister les fichiers se terminant par 'traj-1.dat'
fichiers <- list.files(path = "../OUTPUT/", pattern = "traj-1\\.dat$")


all.df <- data.frame()
lastRow.df <- data.frame()
for(i in 1:length(fichiers)){
  df <- read.csv(paste0("../OUTPUT/",fichiers[i]),  header = FALSE, sep = "", stringsAsFactors = FALSE)
  df$traj <- i 
  all.df <- rbind(all.df, df)
  lastRow.df <- rbind(lastRow.df, tail(df, n = 1))
}

write.csv(all.df, "/tmp/viab_all_traj.csv", row.names = F)
write.csv(all.df, "/tmp/viab_all_traj_lastRow.csv", row.names = F)



# Compter les occurrences des couples (V1, V2)
counts <- all.df %>%
  group_by(V1, V2) %>%
  summarise(count = n(), .groups = "drop")%>%
  as.data.frame()

colnames(counts) <- c("biomass", "capital", "occurence")



ggplot() +
  geom_hex(data = counts, aes(biomass, capital), bins = 50) +
  geom_point(data = lastRow.df, aes(x = V1, y = V2), alpha = 0.2)+
  scale_fill_gradient(low = "#fee0d2", high = "#de2d26") +
  labs(title = "Densité de point de toutes les trajectoires viables", fill = "Nombre\nde points\npar unité\nde surface",
       x = "Biomasse", y = "Capital") +
  theme_bw()
