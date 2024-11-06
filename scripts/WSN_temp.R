#WSN PLOTS! 




















#Plot global map with points colored by species
ggplot() +
  geom_sf(data = world, color="transparent", fill = "grey60")+
  geom_sf(data = subsidies_map_sf, aes(fill=type_of_ecological_effect),
          size = 3,
          color = "transparent",
          pch=21)+
  coord_sf(crs = st_crs('ESRI:54030'))+
#  scale_fill_manual(values = c("#663366", "#3b538c", 
#                               "#1d918c", "grey35", "#7AD151FF"), 
#                    labels = c("Cetaceans", "Pinnipeds", "Sea Otters",
#                               "Marine Mammals\n(multiple groups\nor unknown)", "Sea Turtles"))+
  theme_minimal()+
  theme(legend.position = "none")



ggsave("temp/WSN/effect_map.png", width = 7, height = 5, units = "in")


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





effects_histogram <- ggplot(data=subsidies_map, aes(x=decimal_latitude, fill = type_of_ecological_effect))+
  geom_histogram(bins=15,
                 breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90))+
  geom_vline(xintercept = seq(-90, 90, by = 15), color = "white")+  # Add vertical lines
  scale_x_continuous(breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90),
                     expand = c(0, 0))+
#  scale_fill_manual(values = c("#663366", "#3b538c", 
#                               "#1d918c", "grey35", "#7AD151FF"), 
#                    labels = c("Cetaceans", "Pinnipeds", "Sea Otters",
#                               "Marine Mammals (unknown)", "Sea Turtles"))+
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
ggsave("temp/WSN/effects_legend.png", width = 2.2, height = 2, units = "in")


#Remove legend and export histogram as .png
effects_histogram +
  theme(legend.position = "none")

ggsave("temp/WSN/effect_histogram.png", width = 2, height = 4, units = "in")
