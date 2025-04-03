##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 01: Clean, Process, and Summarize Data ##########################
#-------------------------------------------------------------------------

###############################
# Clean and Process Data ######
###############################

# Part 1: Import Raw Datasets --------------------------------------------
Marine_Megafauna_Consumers <- read_csv("data/raw/Marine_Megafauna_Consumers.csv")
Marine_Megafauna_Subsidies <- read_csv("data/raw/Marine_Megafauna_Subsidies.csv")
Marine_Megafauna_Abundance <- read_csv("data/raw/Megafauna_Abundance.csv")


# Part 2: Clean "Marine Megafauna Consumers" dataset ---------------------

consumers <- Marine_Megafauna_Consumers %>% 
  clean_names()

# We want to make an alternative "consumers" dataset that is more conservative and filters out all potentially duplicated species interactions. Duplicated species interactions could arise due to uncertainties in reported taxonomy of either the megafauna species or consumer species. First, we will begin by looking at duplicates emerging from uncertainty in the marine megafauna taxa. 

#Create dataframe "known_megafauna" in which the megafauna species was reported
known_megafauna <- consumers %>% 
  filter(!is.na(marine_megafauna_species)) 

#Create dataframe "unknown_megafauna" in which the megafauna species was NOT reported
unknown_megafauna <- consumers %>% 
  filter(is.na(marine_megafauna_species)) 

#Determine the rows that may be potentially double-counting species interactions due to uncertainty in the taxonomic reporting of the megafauna species. For example, if a paper reports a coyote eating a whale and another paper reports a coyote eating a humpback whale, then the row that has less taxonomic certainty (a coyote eating a whale) will end up in the duplicate_megafauna dataframe. We will then remove these prior to analyses/visualization. 
duplicate_megafauna <- unknown_megafauna %>%
  #Join unknown_megafauna with "known_megafauna" to see if the combination of consumer species and megafauna group already exist within the "known_megafauna" file. If it does, we will exclude to prevent double-counting a species combination. If not, we will include the unique  interaction. 
  left_join(known_megafauna[, c("marine_megafauna_group","marine_megafauna_common_name", "consumer_common_name")], by = c("marine_megafauna_group", "consumer_common_name"))%>%
  #Flag potentially double counted interactions
  mutate(double_counted = ifelse(is.na(marine_megafauna_common_name.y), FALSE, TRUE)) %>% 
  #Filter for only potentially double counted interactions
  filter(double_counted == TRUE) %>% 
  #Remove irrelevant columns
  select(-marine_megafauna_common_name.y, -double_counted) %>% 
  #rename columns for anti_joining
  rename(marine_megafauna_common_name = marine_megafauna_common_name.x) %>% 
  #keep only distinct rows
  distinct()


#Next, we need to repeat the above process for situations in which the taxonomy of the consumer was uncertain. These are much less common and require some manual double-checking. 

#Create dataframe "duplicate_consumer" in which the consumer species may be potentially double-counted
duplicate_consumer <- consumers %>% 
  #select all rows in which consumer_species is NA (no species reported)
  filter(is.na(consumer_species))%>% 
  #keep only rows that may be duplicated (ID'ed via manual checking)
  filter(consumer_common_name == "Monitor Lizard (Varanus spp.)" |
           marine_megafauna_common_name == "California sea lion")

#Filter duplicate_megafauna and duplicate_consumer rows from "consumers" dataframe
filtered_consumers <- consumers %>% 
  anti_join(duplicate_megafauna) %>% 
  anti_join(duplicate_consumer)


# Part 3: Clean "Marine Megafauna Subsidies" dataset ---------------------

subsidies <- Marine_Megafauna_Subsidies %>% 
  clean_names()


# Part 4: Clean "Marine Megafauna Abundance" dataset ---------------------

abundance <- Marine_Megafauna_Abundance %>% 
  clean_names()

# Part 5: Export cleaned datasets ----------------------------------------

write_csv(consumers, "data/processed/consumers.csv")
write_csv(filtered_consumers, "data/processed/filtered_consumers.csv")
write_csv(subsidies, "data/processed/subsidies.csv")
write_csv(abundance, "data/processed/abundance.csv")


#######################
# Summarize Data ######
#######################

#Clear console and import clean, processed datasets
rm(list=ls())

consumers <- read_csv("data/processed/consumers.csv")
filtered_consumers <- read_csv("data/processed/filtered_consumers.csv")
subsidies <- read_csv("data/processed/subsidies.csv") 


#-------------------------------------------------------------------------------
# Part 1: Summarize info about consumer species and interactions ---------------
#-------------------------------------------------------------------------------

# We will use the "filtered consumers" dataset (see data dictionary for more details)


# How many unique megafauna-consumer species combinations total? #### 

print(nrow(filtered_consumers))

# How many unique megafauna-consumer species combinations for each megafauna group? #### 

print(filtered_consumers %>% 
  group_by(marine_megafauna_group) %>% 
  summarise(n_combinations = n(), .groups="drop"))

# How many unique consumer species for each megafauna group? ####

print(filtered_consumers %>%
        #Select relevant columns 
        select(marine_megafauna_group, consumer_common_name)%>% 
        unique() %>%  # Remove duplicates
        group_by(marine_megafauna_group) %>%
        summarise(consumer_species_count = n(), .groups = 'drop'))

# Question 1: How many unique consumer species are there for each megafauna group and interaction type? ####

print(filtered_consumers %>% 
  #Create TRUE/FALSE category "other consumption" that is true when there is documented consumption of placenta, excreta, or eggs. 
  mutate(other_consumption = if_else(consuming_placenta == TRUE | 
                                       consuming_excreta == TRUE | 
                                       consuming_eggs == TRUE, TRUE, FALSE)) %>% 
  #Select relevant columns 
  select(marine_megafauna_group, consumer_common_name, predation, scavenging, other_consumption) %>% 
  #Pivot for plotting
  pivot_longer(cols = c(predation, scavenging, other_consumption), 
               names_to = "interaction_type", 
               values_to = "interaction_occurred") %>% 
  # Filter for rows where the interaction occurred
  filter(interaction_occurred == TRUE) %>%
  select(-interaction_occurred) %>% # Remove the logical column
  unique() %>%  # Remove duplicates
  group_by(marine_megafauna_group, interaction_type) %>%
  summarise(consumer_species_count = n(), .groups = 'drop'))

#-------------------------------------------------------------------------------
# Part 1: Summarize info about interaction types -------------------------------
#-------------------------------------------------------------------------------
