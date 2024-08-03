##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 02: Consumer Analyses and Plots #################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------
consumers <- read_csv("data/processed/consumers.csv")
filtered_consumers <- read_csv("data/processed/filtered_consumers.csv")

# Part 2: Diversity Sankey Plot with ggsankey ----------------------------


plot_df <- filtered_consumers %>% 
  make_long(marine_megafauna_group, consumer_class) %>% 
  mutate(node = factor(node, levels = c(
    "Armadillo", "Bat", "Sea Turtles", "Bird", 
    "Sirenian", "Fissipeds","Pinnipeds", "Carnivore", 
    "Rodent", "Marsupial", "Cetaceans", "Ungulate",  "Reptile")))

ggplot(plot_df, aes(x = x, 
                    next_x = next_x, 
                    node = node, 
                    next_node = next_node,
                    fill = factor(node), 
                    label = node)) +
  geom_sankey() +
  scale_fill_viridis_d(alpha = 0.85, drop = FALSE) +
  theme_sankey(base_size = 10) +
  theme(legend.position = "none") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())#+
 #geom_sankey_label() #toggles whether ot not there are labels on each node



# Part 2: Diversity Sankey Plot with ggalluvial --------------------------------

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
              "Sirenian" = "#287c8e", "Fissiped" = "#31688e", 
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
  geom_alluvium(width = 1/12, curve_type = "sigmoid", aes(fill = marine_megafauna_group))+
  scale_fill_manual(values = flow_pal, guide = "none") +
  geom_stratum(width=1/12, fill = stratum_pal, color = "transparent")+
#  geom_text(stat = "stratum", aes(label = after_stat(stratum))) + #Toggles labels on/off
  theme_void()
  
  

