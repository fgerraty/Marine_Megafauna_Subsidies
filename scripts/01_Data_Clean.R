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
ESA_Megafauna_Abundance <- read_csv("data/raw/ESA_Megafauna_Abundance.csv",
                                    col_types = cols(
                                      "Growth Rate(%)" = col_character()))


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

# Part 5: Clean "Marine Megafauna ESA" dataset ---------------------------

ESA_abundance <- ESA_Megafauna_Abundance %>% 
  clean_names()

# Part 6: Export cleaned datasets ----------------------------------------

write_csv(consumers, "data/processed/consumers.csv")
write_csv(filtered_consumers, "data/processed/filtered_consumers.csv")
write_csv(subsidies, "data/processed/subsidies.csv")
write_csv(abundance, "data/processed/abundance.csv")
write_csv(ESA_abundance, "data/processed/ESA_abundance.csv")

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

nrow(filtered_consumers)


# How many unique consumer species? #### 

filtered_consumers %>% 
  group_by(marine_megafauna_group) %>% 
  summarise(n_combinations = n(), .groups="drop")

# How many unique megafauna-consumer species combinations for each megafauna group? #### 

nrow(filtered_consumers %>% 
  select(consumer_common_name) %>% 
  distinct())

# How many unique consumer species for each megafauna group? ####

filtered_consumers %>%
  #Select relevant columns 
  select(marine_megafauna_group, consumer_common_name)%>% 
  unique() %>%  # Remove duplicates
  group_by(marine_megafauna_group) %>%
  summarise(consumer_species_count = n(), .groups = 'drop')

# How many unique consumer species are there for each megafauna group and interaction type? ####

filtered_consumers %>% 
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
  summarise(consumer_species_count = n(), .groups = 'drop')

# How many consumer species in each family? #### 

filtered_consumers %>% 
  select(consumer_common_name, consumer_family) %>% 
  distinct() %>% 
  group_by(consumer_family) %>% 
  summarise(n_species = n()) %>% 
  arrange(-n_species)

#-------------------------------------------------------------------------------
# Part 2: Summarize info about predation ---------------------------------------
#-------------------------------------------------------------------------------

# How many unique predator-prey species pairs?
filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  select(marine_megafauna_common_name, consumer_common_name) %>% 
  unique()%>% 
  nrow()

# How many predator species total? 
filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  select(consumer_common_name) %>% 
  unique() %>%
  nrow()

# How many prey species total? 
filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  select(marine_megafauna_common_name) %>% 
  unique() %>%
  nrow()

# Are there taxa that are more commonly documented as prey? 
filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  group_by(marine_megafauna_group) %>% 
  summarise(n_species = n(),.groups = "drop")

# Are there taxa that are more commonly documented as predators? 
filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  group_by(consumer_class) %>% 
  summarise(n_pairs = n(),.groups = "drop")

filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  group_by(consumer_group) %>% 
  summarise(n_pairs = n(),.groups = "drop")

filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  group_by(consumer_family) %>% 
  summarise(n_pairs = n(),.groups = "drop") %>% 
  arrange(-n_pairs)

# Are there taxonomic trends in predator-prey relationships?
filtered_consumers %>% 
  filter(predation == TRUE) %>% 
  group_by(marine_megafauna_group, consumer_group) %>% 
  summarise(n_species_pairs = n(),.groups = "drop")

#-------------------------------------------------------------------------------
# Part 3: Summarize info about scavenging --------------------------------------
#-------------------------------------------------------------------------------

# How many unique scavenger-carrion species pairs?
filtered_consumers %>% 
   filter(scavenging == TRUE) %>% 
   select(marine_megafauna_common_name, consumer_common_name) %>% 
   unique()%>% 
   nrow()

# How many scavenger species total? 
filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  select(consumer_common_name) %>% 
  unique() %>% 
  nrow()

# How many marine megafauna species total? 
filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  select(marine_megafauna_common_name) %>% 
  unique() %>% 
  nrow()

# Are there taxa that are more commonly documented as carrion? 
filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  group_by(marine_megafauna_group) %>% 
  summarise(n_species = n(),.groups = "drop")

# Are there taxa that are more commonly documented as scavengers? 
filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  group_by(consumer_group) %>% 
  summarise(n_species = n(),.groups = "drop")

filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  group_by(consumer_class) %>% 
  summarise(n_species = n(),.groups = "drop")

filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  group_by(consumer_family) %>% 
  summarise(n_species = n(),.groups = "drop") %>% 
  arrange(-n_species)

# Are there taxonomic trends in scavenger-carrion relationships?
filtered_consumers %>% 
  filter(scavenging == TRUE) %>% 
  group_by(marine_megafauna_group, consumer_group) %>% 
  summarise(n_species_pairs = n(),.groups = "drop")

#-------------------------------------------------------------------------------
# Part 4: Summarize info about egg consumption ---------------------------------
#-------------------------------------------------------------------------------

# How many unique sea turtle - egg consumer species pairs?
filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  select(marine_megafauna_common_name, consumer_common_name) %>% 
  unique()%>% 
  nrow()

# How many egg consumer species total? 
filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  select(consumer_common_name) %>% 
  unique() %>% 
  nrow()

# Are there taxa that are more commonly documented as egg consumers? 
filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  group_by(consumer_group) %>% 
  summarise(n_species = n(),.groups = "drop")

filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  group_by(consumer_class) %>% 
  summarise(n_species = n(),.groups = "drop")

filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  group_by(consumer_family) %>% 
  summarise(n_species = n(),.groups = "drop") %>% 
  arrange(-n_species)

#How many classes of consumers? 
filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  select(consumer_class) %>% 
  unique() %>% 
  nrow()

#How many families of consumers?
filtered_consumers %>% 
  filter(consuming_eggs == TRUE) %>% 
  select(consumer_family) %>% 
  unique() %>% 
  nrow()

#-------------------------------------------------------------------------------
# Part 5: Summarize info about placenta/excreta consumption --------------------
#-------------------------------------------------------------------------------

# How many unique marine mammal - placenta consumer species pairs?
filtered_consumers %>% 
  filter(consuming_placenta == TRUE) %>% 
  select(marine_megafauna_common_name, consumer_common_name) %>% 
  unique()%>% 
  nrow()

# How many placenta consumer species total? 
filtered_consumers %>% 
  filter(consuming_placenta == TRUE) %>% 
  select(consumer_common_name) %>% 
  unique() %>% 
  nrow()

# How many placenta source species total? 
filtered_consumers %>% 
  filter(consuming_placenta == TRUE) %>% 
  select(marine_megafauna_common_name) %>% 
  unique() %>% 
  nrow()

# Are there taxa that are more commonly documented as placenta consumers? 
filtered_consumers %>% 
  filter(consuming_placenta == TRUE) %>% 
  group_by(consumer_group) %>% 
  summarise(n_species = n(),.groups = "drop")


# How many unique marine mammal - excreta consumer species pairs?
filtered_consumers %>% 
  filter(consuming_excreta == TRUE) %>% 
  select(marine_megafauna_common_name, consumer_common_name) %>% 
  unique()%>% 
  nrow()

# How many excreta consumer species total? 
filtered_consumers %>% 
  filter(consuming_excreta == TRUE) %>% 
  select(consumer_common_name) %>% 
  unique() %>% 
  nrow()

# Are there taxa that are more commonly documented as excreta consumers? 
filtered_consumers %>% 
  filter(consuming_excreta == TRUE) %>% 
  group_by(consumer_group) %>% 
  summarise(n_species = n(),.groups = "drop")


# Combined! 
# How many unique marine mammal - placenta/excreta consumer species pairs?
filtered_consumers %>% 
  filter(consuming_placenta == TRUE | consuming_excreta == TRUE) %>% 
  select(marine_megafauna_common_name, consumer_common_name) %>% 
  unique()%>% 
  nrow()

# How many placenta/excreta consumer species total? 
filtered_consumers %>% 
  filter(consuming_placenta == TRUE | consuming_excreta == TRUE) %>% 
  select(consumer_common_name) %>% 
  unique() %>% 
  nrow()

# Are there taxa that are more commonly documented as placenta/excreta consumers? 
filtered_consumers %>% 
  filter(consuming_placenta == TRUE | consuming_excreta == TRUE) %>% 
  group_by(consumer_group) %>% 
  summarise(n_species = n(),.groups = "drop")



#-------------------------------------------------------------------------------
# Part 5: Summarize info about subsidy effects ---------------------------------
#-------------------------------------------------------------------------------

# How many studies documented ecological effects of marine megafauna subsidies?
subsidies %>% 
  select(source) %>% 
  unique() %>% 
  nrow()
  
# How many studies for each subsidy type?
subsidies %>% 
  select(type_of_marine_megafauna_subsidy, source) %>% 
  unique() %>% 
  group_by(type_of_marine_megafauna_subsidy) %>% 
  summarise(n_studies = n())

# How many studies for ecological effect category?
subsidies %>%
  select(source, type_of_ecological_effect) %>% 
  unique() %>% 
  separate_rows(type_of_ecological_effect, sep = ",\\s*") %>%  # separate by commas, remove extra space
  group_by(type_of_ecological_effect) %>%
  summarise(n_studies = n()) %>% 
  mutate(percent = n_studies/63)

# How many studies showing multiple ecological effects? 
subsidies %>%
  select(source, type_of_ecological_effect) %>% 
  unique() %>% 
  mutate(effect_type = if_else(str_detect(type_of_ecological_effect, ","), 
                               "multiple", "single")) %>%
  count(effect_type)


