##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 0X: Tally Number of Studies for each megafauna type + interaction type  #
#-------------------------------------------------------------------------


# PART 1: Import Data ----------------------------------------------------
consumers <- read_csv("data/processed/consumers.csv")
subsidies <- read_csv("data/processed/subsidies.csv") 

# PART 2: Predation: Tally number of studies and consumers for each megafauna group ------

predation_studies <- consumers %>% #We will use the "consumers" dataset, which includes all studies with extracted data
  #First, lump sea otters (Fissipeds) and Sirenians (Manatees and Dugongs) together into one marine megafauna group
  mutate(marine_megafauna_group = if_else(marine_megafauna_group %in% c("Fissipeds", "Sirenian"), 
                                          "Fissiped or Sirenian", 
                                          marine_megafauna_group)) %>% 
  #Second, filter for only species pairs in which predation was documented
  filter(predation == TRUE)

#Assess number of studies documenting predation for each megafauna group
print(predation_studies %>%  #Use dataset filtered only for predation
  select(1,15:29) %>%  #Only keep marine megafauna group and sources
  #Pivot longer to vertically join sources #1, #2, and #3
  pivot_longer(
    cols = starts_with("source_"), # Select all columns that start with "source_"
    names_to = c("source", ".value"), # "source" will hold the source number (1, 2, 3)
    names_pattern = "source_(\\d+)_(.*)") %>%  # Regular expression to extract the source number and column name
  #Drop blank rows
  drop_na(type) %>% 
  #Filter for rows with "Predation" or "predation" in the interaction_type column (the source must show predation)
  filter(str_detect(interaction_type, "Predation")) %>% 
  group_by(marine_megafauna_group) %>%   #Group by megafauna group
  distinct(title, .keep_all = TRUE) %>%  # Filter for studies unique to the megafauna group, keeping unique values of other variables
summarise(case_study_count = n(), .groups = "drop")) #Count total number of studies


#Assess number of consumers documented hunting each megafauna group         
print(predation_studies %>% #Use dataset filtered only for predation
        select(marine_megafauna_group, consumer_species) %>% #only keep marine megafauna group and species columns
        unique() %>% #remove duplicates (i.e. same consumer species different megafauna species in same group)
        group_by(marine_megafauna_group) %>% #Group by megafauna group
        summarise(consumer_species_count = n())) #Print count of unique consumers




# PART 3: Scavenging: Tally number of consumers and studies for each megafauna group ------

scavenging_studies <- consumers %>% #We will use the "consumers" dataset, which includes all studies with collected data
  #First, lump sea otters (Fissipeds) and Sirenians (Manatees and Dugongs) together into one marine megafauna group
  mutate(marine_megafauna_group = if_else(marine_megafauna_group %in% c("Fissipeds", "Sirenian"), 
                                          "Fissiped or Sirenian", 
                                          marine_megafauna_group)) %>% 
  #Second, filter for only species pairs in which predation was documented
  filter(scavenging == TRUE)

#Assess number of studies documenting scavenging for each megafauna group
print(scavenging_studies %>%  #Use dataset filtered only for predation
        select(1,15:29) %>%  #Only keep marine megafauna group and sources
        #Pivot longer to vertically join sources #1, #2, and #3
        pivot_longer(
          cols = starts_with("source_"), # Select all columns that start with "source_"
          names_to = c("source", ".value"), # "source" will hold the source number (1, 2, 3)
          names_pattern = "source_(\\d+)_(.*)") %>%  # Regular expression to extract the source number and column name
        #Drop blank rows
        drop_na(type) %>% 
        #Filter for rows with "Scavenging" in the interaction_type column (the source must show scavenging)
        filter(str_detect(interaction_type, "Scavenging")) %>% 
        group_by(marine_megafauna_group) %>%   #Group by megafauna group
        distinct(title, .keep_all = TRUE) %>%  # Filter for studies unique to the megafauna group, keeping unique values of other variables
        summarise(case_study_count = n(), .groups = "drop")) #Count total number of studies


#Assess number of consumers of each megafauna group         
print(scavenging_studies %>% #Use dataset filtered only for predation
        select(marine_megafauna_group, consumer_species) %>% #only keep marine megafauna group and species columns
        unique() %>% #remove duplicates (i.e. same consumer species different megafauna species in same group)
        group_by(marine_megafauna_group) %>% #Group by megafauna group
        summarise(consumer_species_count = n())) #Print count of unique consumers



# PART 4: Consuming eggs, placenta, or excreta: Tally number of consumers and studies for each megafauna group ------

other_consumption_studies <- consumers %>% #We will use the "consumers" dataset, which includes all studies with collected data
  #First, lump sea otters (Fissipeds) and Sirenians (Manatees and Dugongs) together into one marine megafauna group
  mutate(marine_megafauna_group = if_else(marine_megafauna_group %in% c("Fissipeds", "Sirenian"), 
                                          "Fissiped or Sirenian", 
                                          marine_megafauna_group)) %>% 
  #Second, filter for only species pairs in which any of the "other" consumption types was documented
  filter(consuming_placenta == TRUE | consuming_excreta == TRUE | consuming_eggs == TRUE)


#Assess number of studies documenting other consumption types for each megafauna group
print(other_consumption_studies %>%  #Use dataset filtered only for other consumption types
        select(1,15:29) %>%  #Only keep marine megafauna group and sources
        #Pivot longer to vertically join sources #1, #2, and #3
        pivot_longer(
          cols = starts_with("source_"), # Select all columns that start with "source_"
          names_to = c("source", ".value"), # "source" will hold the source number (1, 2, 3)
          names_pattern = "source_(\\d+)_(.*)") %>%  # Regular expression to extract the source number and column name
        #Drop blank rows
        drop_na(type) %>% 
        #Filter for rows with "Consuming placenta", "Consuming excreta" or "Consuming eggs" in the interaction_type column
        filter(str_detect(interaction_type, "Consuming placenta|Consuming excreta|Consuming eggs")) %>% 
        group_by(marine_megafauna_group) %>%   #Group by megafauna group
        distinct(title, .keep_all = TRUE) %>%  # Filter for studies unique to the megafauna group, keeping unique values of other variables
        summarise(case_study_count = n(), .groups = "drop")) #Count total number of studies


#Assess number of consumers of each megafauna group         
print(other_consumption_studies %>% #Use dataset filtered only for predation
        select(marine_megafauna_group, consumer_species) %>% #only keep marine megafauna group and species columns
        unique() %>% #remove duplicates (i.e. same consumer species different megafauna species in same group)
        group_by(marine_megafauna_group) %>% #Group by megafauna group
        summarise(consumer_species_count = n())) #Print count of unique consumers

# PART 5: Marine Megafauna Vectored Nutrients ####

unique(subsidies$type_of_marine_megafauna_subsidy)
