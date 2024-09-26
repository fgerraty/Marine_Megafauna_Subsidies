#Create dataframe for plotting diversity sankey plot
plot_df2 <- filtered_consumers %>% 
  group_by(marine_megafauna_group, consumer_class) %>% #group by consumer-resource combo
  summarise(freq = n(), .groups="drop") %>% #count # of spp. combinations in each group
  bind_rows(blank_rows) %>% #bring in blank rows for plotting aesthetics
  #Turn axis variables into factors
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Marsupial","blank7","Armadillo",
                                                            "blank8", "Rodent","blank9", "Ungulate",
                                                            "blank10","Carnivore", "blank11","Bat", 
                                                             "blank5", "Bird","blank6","Reptile"
         ))) 



#Create dataframe for plotting diversity sankey plot
plot_df3 <- filtered_consumers %>% 
  group_by(marine_megafauna_group, consumer_class) %>% #group by consumer-resource combo
  summarise(freq = n(), .groups="drop") %>% #count # of spp. combinations in each group
  bind_rows(blank_rows) %>% #bring in blank rows for plotting aesthetics
  #Turn axis variables into factors
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC", "Reptile", "blank5", "Bird",
                                                            "blank11","Bat", "blank10","Carnivore",
                                                            "blank9", "Ungulate","blank8", "Rodent",
                                                            "blank7","Armadillo", "blank6","Marsupial"
                                                            ))) 


#Create dataframe for plotting diversity sankey plot
plot_df4 <- filtered_consumers %>% 
  group_by(marine_megafauna_group, consumer_class) %>% #group by consumer-resource combo
  summarise(freq = n(), .groups="drop") %>% #count # of spp. combinations in each group
  bind_rows(blank_rows) %>% #bring in blank rows for plotting aesthetics
  #Turn axis variables into factors
  mutate(marine_megafauna_group = factor(marine_megafauna_group, 
                                         levels = c("blankA","Cetaceans","blank1","Pinnipeds",
                                                    "blank2", "Fissipeds","blank3",
                                                    "Sirenian","blank4","Sea Turtles", "blankB")),
         consumer_class = factor(consumer_class, levels = c("blankC","Bat", "blank10","Carnivore",
                                                            "blank8", "Rodent","blank9", "Ungulate",
                                                            "blank7","Armadillo","blank11", "Marsupial",
                                                            "blank5", "Bird","blank6","Reptile"
         ))) 


stratum_pal3 <- c("transparent", "#7AD151FF", "transparent", "#22A884FF", 
                 "transparent", "#2A788EFF", "transparent", "#414487FF", 
                 "transparent", "#440154FF","transparent",
                 #Second Axis
                 "#FAC62DFF","transparent","#FCA50AFF", "transparent",
                 "#F8850FFF","transparent","#ED6925FF", "transparent",
                 "#DD513AFF","transparent", "#C73E4CFF", "transparent",
                  "#AE305CFF","transparent", "#932667FF", "transparent"
                 
                   
                  )
