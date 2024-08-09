##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 02: Consumer Analyses and Plots #################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------
consumers <- read_csv("data/processed/consumers.csv")
filtered_consumers <- read_csv("data/processed/filtered_consumers.csv")

# Part 2: Diversity sankey plot with ggalluvial --------------------------------

#Create color palette: 

stratum_pal <- c("transparent", "#443983", "transparent", "#31688e", 
                 "transparent", "#287c8e", "transparent", "#20a486", 
                 "transparent", "#90d743","transparent",
                 #Second Axis
                 "#440154", "transparent", "#481f70","transparent", 
                 "#3b528b", "transparent", "#21918c","transparent",
                 "#35b779", "transparent", "#5ec962","transparent",
                 "#c8e020", "transparent", "#fde725","transparent")

flow_pal <- c("blank1" = "transparent", "blank2"="transparent", "blank3"= "transparent", 
              "blank4"= "transparent", "blankA" = "transparent","blankB" = "transparent",
              "Cetaceans" =  "#90d743", "Pinnipeds" = "#20a486", 
              "Fissipeds" = "#287c8e", "Sirenian" = "#31688e", 
              "Sea Turtles" = "#443983")
                 

#Create dataframe of blank rows
blank_rows <- tibble(
  marine_megafauna_group = c("blank1", "blank2", "blank3", "blank4", rep("blankA", 4), rep("blankB", 3)),
  consumer_class = c(rep("blankC", 4), "blank5", "blank6", "blank7", "blank8", "blank9", "blank10", "blank11"),
  freq = rep(10, 11)
)



plot_df <- filtered_consumers %>% 
  group_by(marine_megafauna_group, consumer_class) %>% 
  summarise(freq = n(), .groups="drop") %>% 
  bind_rows(blank_rows) %>% 
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Ungulate", "blank5",
                                                            "Rodent","blank6","Reptile",
                                                            "blank7","Marsupial", "blank8", 
                                                            "Carnivore", "blank9", "Bird",
                                                            "blank10","Bat","blank11", 
                                                            "Armadillo")))


ggplot(data=plot_df, aes(axis1=marine_megafauna_group, 
                                    axis2=consumer_class,
                                    y=freq))+
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75,
                aes(fill = marine_megafauna_group))+
  scale_fill_manual(values = flow_pal, guide = "none") +
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
#  geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()
  
ggsave("output/extra_plots/sankey_figure/diversity_sankey.png", width = )
  

# Part 3: Interaction type sankey plots with ggalluvial --------------------------------

#Part 3A: Scavenging sankey plot ####

scav_sankey_df <- consumers %>% 
  group_by(marine_megafauna_group, consumer_class, scavenging) %>% 
  summarise(freq = n(), .groups="drop") %>% 
  bind_rows(blank_rows) %>% 
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Ungulate", "blank5",
                                                            "Rodent","blank6","Reptile",
                                                            "blank7","Marsupial", "blank8", 
                                                            "Carnivore", "blank9", "Bird",
                                                            "blank10","Bat","blank11", 
                                                            "Armadillo")))


ggplot(data=scav_sankey_df, aes(axis1=marine_megafauna_group, 
                         axis2=consumer_class,
                         y=freq))+
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75,
                aes(fill = scavenging))+
  scale_fill_manual(values = c("grey80", "#003049"), #FALSE = "grey", TRUE = "orange
                    na.value = "transparent", #Fill NA values with transparent fill
                    guide="none") + #remove legend
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
 #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()

#Part 3B: Predation sankey plot ####

predation_sankey_df <- consumers %>% 
  group_by(marine_megafauna_group, consumer_class, predation) %>% 
  summarise(freq = n(), .groups="drop") %>% 
  bind_rows(blank_rows) %>% 
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Ungulate", "blank5",
                                                            "Rodent","blank6","Reptile",
                                                            "blank7","Marsupial", "blank8", 
                                                            "Carnivore", "blank9", "Bird",
                                                            "blank10","Bat","blank11", 
                                                            "Armadillo")))


ggplot(data=predation_sankey_df, aes(axis1=marine_megafauna_group, 
                                axis2=consumer_class,
                                y=freq))+
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75,
                aes(fill = predation))+
  scale_fill_manual(values = c("grey80", "#D62828"), #FALSE = "grey", TRUE = "orange
                    na.value = "transparent", #Fill NA values with transparent fill
                    guide="none") + #remove legend
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
  #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()

#Part 3C: Egg consumption sankey plot ####

egg_sankey_df <- consumers %>% 
  group_by(marine_megafauna_group, consumer_class, consuming_eggs) %>% 
  summarise(freq = n(), .groups="drop") %>% 
  bind_rows(blank_rows) %>% 
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Ungulate", "blank5",
                                                            "Rodent","blank6","Reptile",
                                                            "blank7","Marsupial", "blank8", 
                                                            "Carnivore", "blank9", "Bird",
                                                            "blank10","Bat","blank11", 
                                                            "Armadillo")))


ggplot(data=egg_sankey_df, aes(axis1=marine_megafauna_group, 
                                     axis2=consumer_class,
                                     y=freq))+
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75,
                aes(fill = consuming_eggs))+
  scale_fill_manual(values = c("grey80", "#F77F00"), #FALSE = "grey", TRUE = "orange
                    na.value = "transparent", #Fill NA values with transparent fill
                    guide="none") + #remove legend
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
  #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()


#Part 3D: Placenta/excreta consumption sankey plot ####

placenta_excreta_sankey_df <- consumers %>% 
  mutate(consuming_placenta_excreta = if_else(consuming_placenta == TRUE | 
                                              consuming_excreta == TRUE, 
                                              TRUE, FALSE)) %>% 
  group_by(marine_megafauna_group, consumer_class, consuming_placenta_excreta) %>% 
  summarise(freq = n(), .groups="drop") %>% 
  bind_rows(blank_rows) %>% 
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Ungulate", "blank5",
                                                            "Rodent","blank6","Reptile",
                                                            "blank7","Marsupial", "blank8", 
                                                            "Carnivore", "blank9", "Bird",
                                                            "blank10","Bat","blank11", 
                                                            "Armadillo")))


ggplot(data=placenta_excreta_sankey_df, aes(axis1=marine_megafauna_group, 
                               axis2=consumer_class,
                               y=freq))+
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75,
                aes(fill = consuming_placenta_excreta))+
  scale_fill_manual(values = c("grey80", "#FCBF49"), #FALSE = "grey", TRUE = "orange
                    na.value = "transparent", #Fill NA values with transparent fill
                    guide="none") + #remove legend
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
  #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()


