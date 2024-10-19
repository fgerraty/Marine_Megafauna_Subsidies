##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 00: Load packages ###############################################
#-------------------------------------------------------------------------

packages<- c("tidyverse", "janitor", "ggalluvial", "ggpubr", "sf", "rnaturalearth", "rnaturalearthdata", "ggthemes")

pacman::p_load(packages, character.only = TRUE); rm(packages)
