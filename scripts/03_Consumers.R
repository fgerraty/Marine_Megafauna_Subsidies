##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 03: Consumer Analyses and Plots #################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------
consumers <- read_csv("data/processed/consumers.csv")
filtered_consumers <- read_csv("data/processed/filtered_consumers.csv")

# PART 2: Diversity sankey plot with ggalluvial --------------------------------

#Create color palettes: 

stratum_pal <- c("transparent", "#7AD151FF", "transparent", "#22A884FF", 
                 "transparent", "#2A788EFF", "transparent", "#414487FF", 
                 "transparent", "#440154FF","transparent",
                 #Second Axis
                 "#932667FF", "transparent", "#AE305CFF","transparent", 
                 "#C73E4CFF", "transparent", "#DD513AFF","transparent",
                 "#ED6925FF", "transparent",  "#F8850FFF","transparent",
                 "#FCA50AFF", "transparent", "#FAC62DFF","transparent")

stratum_pal2 <- c("transparent", "grey80", "transparent", "grey80", 
                 "transparent", "grey80", "transparent", "grey80", 
                 "transparent", "grey80","transparent",
                 #Second Axis
                 "grey80", "transparent", "grey80", "transparent", 
                 "grey80", "transparent", "grey80","transparent",
                 "grey80", "transparent",  "grey80","transparent",
                 "grey80", "transparent", "grey80","transparent")

flow_pal <- c("blank1" = "transparent", "blank2"="transparent", "blank3"= "transparent", 
              "blank4"= "transparent", "blankA" = "transparent","blankB" = "transparent",
              "Cetaceans" =  "#440154FF", "Pinnipeds" = "#414487FF", 
              "Fissipeds" = "#2A788EFF", "Sirenian" = "#22A884FF", 
              "Sea Turtles" = "#7AD151FF")            

#Create dataframe of blank rows
blank_rows <- tibble(
  marine_megafauna_group = c("blank1", "blank2", "blank3", "blank4", rep("blankA", 4), rep("blankB", 3)),
  consumer_class = c(rep("blankC", 4), "blank5", "blank6", "blank7", "blank8", "blank9", "blank10", "blank11"),
  freq = rep(10, 11)
)


#Create dataframe for plotting diversity sankey plot
plot_df <- filtered_consumers %>% 
  group_by(marine_megafauna_group, consumer_class) %>% #group by consumer-resource combo
  summarise(freq = n(), .groups="drop") %>% #count # of spp. combinations in each group
  bind_rows(blank_rows) %>% #bring in blank rows for plotting aesthetics
  #Turn axis variables into factors
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

#Plot diversity sankey plot
ggplot(data=plot_df, aes(axis1=marine_megafauna_group, 
                                    axis2=consumer_class,
                                    y=freq))+
  #"Flows" with geom_alluvium
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75,
                aes(fill = marine_megafauna_group))+
  scale_fill_manual(values = flow_pal, guide = "none") +
  #axes with geom_stratum
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
#  geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off, remove in final version of script
  theme_void()
  
ggsave("output/extra_plots/sankey_figure/diversity_sankey.png", width = 4, height = 6, units = "in")
  

# PART 3: Interaction type sankey plots with ggalluvial --------------------------------

# Part 3A: Scavenging sankey plot ####

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
  geom_stratum(width=1/12, fill = stratum_pal2, color = "transparent")+
 #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()


ggsave("output/extra_plots/sankey_figure/scavenging_sankey.png", 
       width = 2, height = 2.5, units = "in")


# Part 3B: Predation sankey plot ####

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
  geom_stratum(width=1/12, fill = stratum_pal2, color = "transparent")+
  #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()


ggsave("output/extra_plots/sankey_figure/predation_sankey.png", 
       width = 2, height = 2.5, units = "in")


# Part 3C: Egg consumption sankey plot ####

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
  geom_stratum(width=1/12, fill = stratum_pal2, color = "transparent")+
  #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()


ggsave("output/extra_plots/sankey_figure/egg_consumption_sankey.png", 
       width = 2, height = 2.5, units = "in")



# Part 3D: Placenta/excreta consumption sankey plot ####

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
  geom_alluvium(width = 1/12, curve_type = "sigmoid", alpha = .75, color = "transparent",
                aes(fill = consuming_placenta_excreta))+
  scale_fill_manual(values = c("grey80", "#219ebc"), #FALSE = "grey", TRUE = "orange
                    na.value = "transparent", #Fill NA values with transparent fill
                    guide="none") + #remove legend
  geom_stratum(width=1/12, fill = stratum_pal2, color = "transparent")+
  #   geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()


ggsave("output/extra_plots/sankey_figure/placenta_excreta_sankey.png", 
       width = 2, height = 2.5, units = "in")


# Part 3E: Manually create color legend for interaction type plots ---------

# Define custom data
legend_data <- data.frame(
  category = c("Scavenging", "Predation", "Egg Consumption", "Placenta and/or Excreta Consumption"),
  x = c(1, 1, 1, 1),
  y = c(1, 2, 3, 4)
) %>% 
  mutate(category = factor(category, levels = c("Scavenging", "Predation", "Egg Consumption", "Placenta and/or Excreta Consumption")))

# Create plot to extract legend from
temp_plot <- ggplot(legend_data, aes(x = x, y = y, fill = category)) +
  geom_tile(aes(width = 0.8, height = 0.8)) +
  scale_fill_manual(values = c(
    "Scavenging" = "#003049",
    "Predation" = "#D62828",
    "Egg Consumption" = "#F77F00",
    "Placenta and/or Excreta Consumption" = "#219ebc"), 
    labels = c("Scavenging", "Predation", 
               "Egg Consumption", "Placenta and/or\nExcreta Consumption")) +
  labs(fill = "") +  
  theme_void() +
  theme(legend.position = "bottom")+
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) #Make legend into two rows

#extract legend using ggpubr::get_legend
legend <- get_legend(temp_plot)
as_ggplot(legend) #turn back into ggplot

#Export legend
ggsave("output/extra_plots/sankey_figure/legend.png", width = 7, height = 1, units = "in")

