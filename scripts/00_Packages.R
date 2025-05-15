##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 00: Load packages ###############################################
#-------------------------------------------------------------------------

#Package versions used for publication
#tidyverse (v2.0.0), janitor (v2.2.1), ggalluvial (v0.12.5), ggpubr (v0.6.0), sf (v1.0.20), rnaturalearth (v1.0.1), rnaturalearthdata (v1.0.0), ggthemes (v5.1.0), pacman (v0.5.1).

packages<- c("tidyverse", "janitor", "ggalluvial", "ggpubr", "sf", "rnaturalearth", "rnaturalearthdata", "ggthemes") 

pacman::p_load(packages, character.only = TRUE); rm(packages)




