##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 02: Consumer Analyses and Plots #################################
#-------------------------------------------------------------------------

#Import Data
consumers <- read_csv("data/processed/consumers.csv")

#Filter out potential duplicate species due to reported taxonomic uncertainties ----

known_megafauna <- consumers %>% 
  filter(!is.na(marine_megafauna_species)) 

unknown_megafauna <- consumers %>% 
  filter(is.na(marine_megafauna_species)) 

temp <- unknown_megafauna %>%
  #Join unknown_megafauna with "known_megafauna" to see if the combination of consumer species and megafauna group already exist within the "known_megafauna" file. If it does, we will exclude to prevent double-counting a species combination. If not, we will include the unique  interaction. 
  left_join(known_megafauna[, c("marine_megafauna_group","marine_megafauna_common_name", "consumer_common_name")], by = c("marine_megafauna_group", "consumer_common_name"))%>%
  #Flag potentially double counted interactions
  mutate(double_counted = ifelse(is.na(marine_megafauna_common_name.y), FALSE, TRUE))

