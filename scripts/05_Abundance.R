##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 05: Megafauna Abundance Plots  ##################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------

abundance <- read_csv("data/processed/abundance.csv") 

# PART 2: Prepara data for plots ---------------------------------------

df <- abundance %>% 
  select(record_lotze_worm, species_group, percent_left_low, percent_left_now) %>% 
  rename(low = percent_left_low, now = percent_left_now) %>% 
  pivot_longer(cols = c(low, now), 
               names_to = "period", values_to = "percent_left")


ggplot(df, aes(x=period, y=percent_left, color=species_group))+
  geom_boxplot()+
  geom_jitter(width = .2)
