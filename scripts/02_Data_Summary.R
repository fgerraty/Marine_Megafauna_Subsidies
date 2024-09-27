##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 02: Summarize extracted data (# studies, # consumers, etc.)  ####
#-------------------------------------------------------------------------


# PART 1: Import Data ----------------------------------------------------
consumers <- read_csv("data/processed/consumers.csv")
subsidies <- read_csv("data/processed/subsidies.csv") 

# PART 2: Tally number of consumers for each megafauna group and interaction type ------

interactions <- consumers %>% #We will use the "consumers" dataset (see data dictionary for more details)
  mutate(other_consumption = if_else(consuming_placenta == TRUE | 
                                       consuming_excreta == TRUE | 
                                       consuming_eggs == TRUE, TRUE, FALSE)) %>% 
  select(marine_megafauna_group, consumer_common_name, predation, scavenging, other_consumption) %>% 
  pivot_longer(cols = c(predation, scavenging, other_consumption), 
               names_to = "interaction_type", 
               values_to = "interaction_occurred") %>% 
  # Filter for rows where the interaction occurred
  filter(interaction_occurred == TRUE) %>%
  select(-interaction_occurred) %>% # Remove the logical column
  unique() %>%  # Remove duplicates
  group_by(marine_megafauna_group, interaction_type) %>%
  summarise(consumer_species_count = n(), .groups = 'drop') %>% 
  #Turn variables into factors for plotting
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("Sea Turtles", "Sirenian","Fissipeds",  "Pinnipeds","Cetaceans")),
         interaction_type = factor(interaction_type, 
                                   levels = c("predation", "scavenging", "other_consumption")))

# PART 3: Plot ------

ggplot(interactions, aes(x=interaction_type, y=consumer_species_count, fill = marine_megafauna_group))+
  geom_bar(position = "stack", stat = "identity")+
  coord_flip()+






# PART 5: Marine Megafauna Vectored Nutrients ####

print(subsidies %>% 
        filter(type_of_marine_megafauna_subsidy == "Marine Megafauna Vectored") %>% 
        #Replace "Pinnipeds (and seabirds)" with "Pinnipeds"
        mutate(marine_megafauna_group = if_else(marine_megafauna_group == "Pinnipeds (and seabirds)",
                                                "Pinnipeds", 
                                                marine_megafauna_group)) %>% 
        group_by(marine_megafauna_group) %>% 
        summarise(study_count = n()))
