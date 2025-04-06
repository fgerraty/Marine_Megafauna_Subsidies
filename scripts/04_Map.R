##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 04: Subsidy Maps ################################################
#-------------------------------------------------------------------------

###############################################
# Import and Prepare Datasets for Plotting ####
###############################################

# PART 1: Import Data ----------------------------------------------------

subsidies <- read_csv("data/processed/subsidies.csv") 

# PART 2: Prepara data for plots ---------------------------------------

subsidies_map <- subsidies %>% 
  #Remove one global study (no lat/long)
  drop_na(decimal_latitude) %>% 
  mutate(
    #Combine studies with multiple marine mammal groups together
    marine_megafauna_map_group = if_else(marine_megafauna_group %in% 
                                           c("Cetaceans, Pinnipeds", 
                                             "Marine Mammals (unspecified)",
                                             "Cetaceans, Pinnipeds, Fissipeds",
                                             "Marine Vertebrates",
                                             "Marine Resources (including pinnipeds)"), 
                                         "Marine Mammals (multiple groups or unknown)",
                                         marine_megafauna_group),
    
    #Remove "(and seabirds)" from studies including both pinniped and seabird subsidies
    marine_megafauna_map_group = if_else(
      marine_megafauna_map_group == "Pinnipeds (and seabirds)",
      "Pinnipeds", marine_megafauna_map_group),
    #Turn "marine_megafauna_map_group" into factor for plotting     
    marine_megafauna_map_group = factor(marine_megafauna_map_group, 
                                        levels = c("Cetaceans", "Pinnipeds", "Fissipeds", 
                                                   "Marine Mammals (multiple groups or unknown)",
                                                   "Sea Turtles")),
    #Remove carcasses as habitat from megafauna subsidy type      
    type_of_marine_megafauna_subsidy = if_else(type_of_marine_megafauna_subsidy == "Marine Megafauna as Food, Marine Megafauna Carcasses as Habitat",
                                               "Marine Megafauna as Food",
                                               type_of_marine_megafauna_subsidy),
  #Group "Type of Ecological Effect" column for plotting
  type_of_ecological_effect = if_else(type_of_ecological_effect %in% c("Consumer behavior", "Consumer health",
                                                  "Consumer abundance", "Community- and ecosystem-level"), type_of_ecological_effect, "Multiple or other effects"),
  
  #Turn into factor for plotting
  type_of_marine_megafauna_subsidy = factor(type_of_marine_megafauna_subsidy, 
                                                   levels = c("Marine Megafauna as Food", 
                                                              "Marine Megafauna Vectored",
                                                              "Indirect Effects")),
  type_of_ecological_effect = factor(type_of_ecological_effect, levels = c("Consumer health","Consumer behavior",
                                                                           "Consumer abundance", "Community- and ecosystem-level","Multiple or other effects"
                                                                           )))

#Create SF object
subsidies_map_sf <- st_as_sf(subsidies_map, 
                             coords = c("decimal_longitude", "decimal_latitude"), 
                             crs = 4326) %>% 
  st_transform(crs = st_crs('ESRI:54030'))


#Prepare dataset for marginal distribution plots
marginal_df <- subsidies_map %>% 
  #Label studies that showed effects of pinnipeds and other marine resources as solely pinnipeds
  mutate(megafauna_marginal_group = case_when(
    marine_megafauna_group %in% c("Pinnipeds (and seabirds)", 
                                  "Marine Resources (including pinnipeds)") ~ "Pinnipeds",
    #And label studies that showed effects of "marine vertebrates" as "Marine Mammals (unspecified)" (as the studies were in areas with only marine mammals and birds)
    marine_megafauna_group == "Marine Vertebrates" ~ "Marine Mammals (unspecified)",
    TRUE ~ marine_megafauna_group)) %>% 
  #Split studies with multiple taxonomic groups into separate rows (this will double-count studies)
  separate_rows(megafauna_marginal_group, sep = ", ") %>% 
  mutate(megafauna_marginal_group = factor(megafauna_marginal_group, 
                                           levels = c("Cetaceans", "Pinnipeds", 
                                                      "Fissipeds", "Marine Mammals (unspecified)",
                                                      "Sea Turtles")))


##########################################
# Megafauna Species Map and Histogram ####
##########################################

# PART 3: Generate Species Map ------------------------------------------------

#Extract world map from rnaturalearth data
world <- ne_countries(scale = "medium", returnclass = "sf")

#Plot global map with points colored by species
ggplot() +
  geom_sf(data = world, color="transparent", fill = "grey60")+
  geom_sf(data = subsidies_map_sf, aes(fill=marine_megafauna_map_group),
             size = 3,
             color = "transparent",
             pch=21)+
  coord_sf(crs = st_crs('ESRI:54030'))+
  scale_fill_manual(values = c("#663366", "#3b538c", 
                               "#1d918c", "grey35", "#7AD151FF"), 
                    labels = c("Cetaceans", "Pinnipeds", "Sea Otters",
                               "Marine Mammals\n(multiple groups\nor unknown)", "Sea Turtles"))+
  theme_minimal()+
  theme(legend.position = "none")
 

ggsave("output/extra_plots/species_map.png", width = 7, height = 5, units = "in")


# PART 4: Plot Species Histogram ------------------------------------------

species_histogram <- ggplot(data=marginal_df, aes(x=decimal_latitude, fill = megafauna_marginal_group))+
  geom_histogram(bins=15,
                 breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90))+
  geom_vline(xintercept = seq(-90, 90, by = 15), color = "white")+  # Add vertical lines
  scale_x_continuous(breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90),
                     expand = c(0, 0))+
  scale_fill_manual(values = c("#663366", "#3b538c", 
                                 "#1d918c", "grey35", "#7AD151FF"), 
                      labels = c("Cetaceans", "Pinnipeds", "Sea Otters",
                                 "Marine Mammals (unknown)", "Sea Turtles"))+
  labs(fill = "Marine Megafauna Group")+
  coord_flip()+  # Flips the chart to be horizontal
  theme_classic() +
  theme(legend.box.background = element_rect(colour = "black", linewidth = 2))+
  labs(x = "Latitude", y= "# Studies")
species_histogram

#Extract legend from species histogram and export as .png
species_legend <- get_legend(species_histogram)
plot <- as_ggplot(species_legend) +
  theme(legend.position = "bottom")
plot
ggsave("output/extra_plots/species_legend.png", width = 2.2, height = 2, units = "in")


#Remove legend and export histogram as .png
species_histogram +
 theme(legend.position = "none")

ggsave("output/extra_plots/latitude_histogram.png", width = 2, height = 4, units = "in")

#####################################
# Subsidy Type Map and Histogram ####
#####################################


# PART 5: Generate Subsidy Type Map ---------------------------------------------


#Plot global map with points colored by subsidy type 
ggplot() +
  geom_sf(data = world, color="transparent", fill = "grey60")+
  geom_sf(data = subsidies_map_sf, aes(fill=type_of_marine_megafauna_subsidy),
          size = 3,
          color = "transparent",
          pch=21)+
  coord_sf(crs = st_crs('ESRI:54030'))+
  scale_fill_manual(values = c( "#219ebc","#F77F00", "#003049"))+
  theme_minimal()+
  theme(legend.position = "none")


ggsave("output/extra_plots/subsidy_type_map.png", width = 7, height = 5, units = "in")


# PART 6: Plot Subsidy Type Histogram ------------------------------------------


subsidy_type_histogram <- ggplot(data=marginal_df, aes(x=decimal_latitude, 
                             fill = type_of_marine_megafauna_subsidy))+
  geom_histogram(bins=15,
                 breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90))+
  geom_vline(xintercept = seq(-90, 90, by = 15), color = "white")+  # Add vertical lines
  scale_x_continuous(breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90),
                     expand = c(0, 0))+
  scale_fill_manual(values = c( "#219ebc","#F77F00", "#003049"))+
  coord_flip()+  # Flips the chart to be horizontal
  theme_classic() +
  theme(legend.box.background = element_rect(colour = "black", linewidth = 2))+
  labs(x = "Latitude", y= "# Studies", fill = "Subsidy Type")

#Extract legend from subsidy type histogram and export as .png
subsidy_type_legend <- get_legend(subsidy_type_histogram)
plot <- as_ggplot(subsidy_type_legend) +
  theme(legend.position = "bottom")
plot
ggsave("output/extra_plots/subsidy_type_legend.png", width = 2.2, height = 2, units = "in")


#Remove legend and export histogram as .png
subsidy_type_histogram +
  theme(legend.position = "none")

ggsave("output/extra_plots/subsidy_type_histogram.png", width = 2, height = 4, units = "in")
 

###########################################
# Ecological Effects Map and Histogram ####
###########################################

# PART 7: Ecological Effects Map -----------------------------------------------

ggplot() +
  geom_sf(data = world, color="transparent", fill = "grey60")+
  geom_sf(data = subsidies_map_sf, aes(fill=type_of_ecological_effect),
          size = 3,
          color = "transparent",
          pch=21)+
  coord_sf(crs = st_crs('ESRI:54030'))+
  scale_fill_manual(values = c("#FFB000", "#FE6100", 
                               "#DC267F", "#785EF0", "#648FFF"))+
  theme_minimal()+
  theme(legend.position = "none")

ggsave("output/extra_plots/ecological_effects_map.png", width = 7, height = 5, units = "in")

# PART 8: Ecological Effects Histogram -----------------------------------------------

effects_histogram <- ggplot(data=subsidies_map, aes(x=decimal_latitude, fill = type_of_ecological_effect))+
  geom_histogram(bins=15,
                 breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90))+
  geom_vline(xintercept = seq(-90, 90, by = 15), color = "white")+  # Add vertical lines
  scale_x_continuous(breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90),
                     expand = c(0, 0))+
  scale_fill_manual(values = c("#FFB000", "#FE6100", 
                               "#DC267F", "#785EF0", "#648FFF"))+
  labs(fill = "Type of Ecological Effect")+
  coord_flip()+  # Flips the chart to be horizontal
  theme_classic() +
  theme(legend.box.background = element_rect(colour = "black", linewidth = 2))+
  labs(x = "Latitude", y= "# Studies")
effects_histogram


#Extract legend from species histogram and export as .png
effects_legend <- get_legend(effects_histogram)
plot <- as_ggplot(effects_legend) +
  theme(legend.position = "bottom")
plot
ggsave("output/extra_plots/effects_legend.png", width = 2.2, height = 2, units = "in")


#Remove legend and export histogram as .png
effects_histogram +
  theme(legend.position = "none")

ggsave("output/extra_plots/effect_histogram.png", width = 2, height = 4, units = "in")
