##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 02: Summarize extracted data (# studies, # consumers, etc.)  ####
#-------------------------------------------------------------------------


# PART 1: Import Data ----------------------------------------------------
consumers <- read_csv("data/processed/consumers.csv")
filtered_consumers <- read_csv("data/processed/filtered_consumers.csv")
subsidies <- read_csv("data/processed/subsidies.csv") 

# PART 2: Tally number of consumers for each megafauna group and interaction type ------

interactions <- filtered_consumers %>% #We will use the "filtered consumers" dataset (see data dictionary for more details)
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
  summarise(consumer_species_count = n(), .groups = 'drop') %>% 
  #Turn variables into factors for plotting
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("Sea Turtles", "Sirenian","Fissipeds",  "Pinnipeds","Cetaceans")),
         interaction_type = factor(interaction_type, 
                                   levels = c("other_consumption", "scavenging","predation")))

# PART 3: Plot ------

pal <- c("Cetaceans" =  "#440154FF", "Pinnipeds" = "#414487FF", 
"Fissipeds" = "#2A788EFF", "Sirenian" = "#22A884FF", 
"Sea Turtles" = "#7AD151FF")


fig1b <- ggplot(interactions, aes(x=interaction_type, y=consumer_species_count, fill = marine_megafauna_group))+
  geom_bar(position = "stack", stat = "identity")+
  coord_flip()+
  scale_fill_manual(values = pal, breaks = c("Cetaceans","Pinnipeds","Fissipeds","Sirenian","Sea Turtles"))+
  scale_y_continuous(position = "right", limits = c(0,70))+
  labs(x = "", y= "", fill = "Marine\nMegafauna\nGroup")+
  theme_classic()+ #Set aesthetics
  #Remove Y axis title and ticks
  theme(axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        legend.box.background = element_rect(colour = "black", linewidth = 2))

#Extract legend from fig1b and export as .png
fig1b_legend <- get_legend(fig1b)
fig1b_legend <- as_ggplot(fig1b_legend) 
ggsave("output/extra_plots/fig1b_legend.png",fig1b_legend, width = 3, height = 2.5, units = "in")


fig1b <- fig1b + 
  theme(legend.position = "none")

ggsave("output/extra_plots/Figure_1B.png", fig1b,
       width = 3, height = 5, units = "in")




# PART 5: Marine Megafauna Vectored Nutrients####

fig1c_df <- subsidies %>% 
        filter(type_of_marine_megafauna_subsidy == "Marine Megafauna Vectored") %>% 
        #Replace "Pinnipeds (and seabirds)" with "Pinnipeds"
        mutate(marine_megafauna_group = if_else(marine_megafauna_group == "Pinnipeds (and seabirds)",
                                                "Pinnipeds", 
                                                marine_megafauna_group)) %>% 
        group_by(marine_megafauna_group) %>% 
        summarise(study_count = n()) %>% 
        mutate(type_of_marine_megafauna_subsidy = "Marine Megafauna Vectored",
               marine_megafauna_group = factor(marine_megafauna_group, levels = c("Sea Turtles", "Pinnipeds")))
      


fig1c <- ggplot(fig1c_df, aes(x=type_of_marine_megafauna_subsidy, y=study_count, fill = marine_megafauna_group))+
  geom_bar(position = "stack", stat = "identity")+
  coord_flip()+
  scale_y_continuous(limits = c(0,70))+
  scale_fill_manual(values = pal, breaks = c("Cetaceans","Pinnipeds","Fissipeds","Sirenian","Sea Turtles"))+
  labs(x = "", y= "", fill = "")+
  theme_classic()+ #Set aesthetics
  #Remove Y axis title and ticks
  theme(axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        legend.position = "none",
        panel.background = element_rect(fill = "transparent", colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA))
fig1c


ggsave("output/extra_plots/Figure_1C.png", fig1c,
       width = 3, height = 2, units = "in")
