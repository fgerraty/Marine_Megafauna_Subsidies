##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 01: Clean and Process Data ######################################
#-------------------------------------------------------------------------

# Part 1: Import Raw Datasets --------------------------------------------
Marine_Megafauna_Consumers <- read_csv("data/raw/Marine_Megafauna_Consumers.csv")
Marine_Megafauna_Subsidies <- read_csv("data/raw/Marine_Megafauna_Subsidies.csv")


# Part 2: Clean "Marine Megafauna Consumers" dataset ---------------------

consumers <- Marine_Megafauna_Consumers %>% 
  clean_names()


# Part 3: Clean "Marine Megafauna Subsidies" dataset ---------------------

subsidies <- Marine_Megafauna_Subsidies %>% 
  clean_names()


# Part 4: Export cleaned datasets ----------------------------------------

write_csv(consumers, "data/processed/consumers.csv")
write_csv(subsidies, "data/processed/subsidies.csv")

