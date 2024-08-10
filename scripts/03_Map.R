##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 03: Subsidy Map #################################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------

subsidies <- read_csv("data/processed/subsidies.csv") %>% 
  drop_na(decimal_latitude) %>% 
  mutate(marine_megafauna_map_group = if_else(marine_megafauna_group %in% 
                          c("Cetaceans, Pinnipeds", 
                            "Marine Mammals (unspecified)",
                            "Cetaceans, Pinnipeds, Fissipeds",
                            "Marine Vertebrates",
                            "Marine Resources (including pinnipeds)"), 
                        "Marine Mammals (multiple groups or unknown)",
                        marine_megafauna_group),
         marine_megafauna_map_group = if_else(
           marine_megafauna_map_group == "Pinnipeds (and seabirds)",
           "Pinnipeds", marine_megafauna_map_group),
         
         marine_megafauna_map_group = factor(marine_megafauna_map_group, levels = c("Cetaceans", "Pinnipeds", "Fissipeds", "Marine Mammals (multiple groups or unknown)", "Sea Turtles"))) 

subsidies_sf <- st_as_sf(subsidies, 
                         coords = c("decimal_longitude", "decimal_latitude"), 
                         crs = 4326) %>% 
  st_transform(crs = st_crs('ESRI:54030'))


# PART 2: Generate Map ---------------------------------------------------

world <- ne_countries(scale = "medium", returnclass = "sf")

ggplot() +
  geom_sf(data = world, color="transparent", fill = "grey60")+
  geom_sf(data = subsidies_sf, aes(fill=marine_megafauna_map_group),
             size = 3,
             color = "transparent",
             pch=21)+
  coord_sf(crs = st_crs('ESRI:54030'))+
  scale_fill_manual(values = c("#440154FF", "#414487FF", 
                               "#2A788EFF", "#22A884FF", "#7AD151FF"), 
                    labels = c("Cetaceans", "Pinnipeds", "Sea Otters",
                               "Marine Mammals\n(multiple groups\nor unknown)", "Sea Turtles"))+
  labs(fill = "Marine Megafauna Group")+
  theme_minimal()+
  theme(legend.position = "bottom")+
  guides(fill = guide_legend())+
  guides(fill=guide_legend(title.position = "top", title.hjust=0.5,
                         #  nrow=2,byrow=TRUE
                           )) #Make legend into two rows


ggsave("output/extra_plots/map.png", width = 7, height = 5, units = "in")

# PART 3: Marginal Distribution plot -------------------------------------------

marginal_df <- subsidies %>% 
  #Label studies that showed effects of pinnipeds and other marine resources as solely pinnipeds
  mutate(megafauna_marginal_group = case_when(
    marine_megafauna_group %in% c("Pinnipeds (and seabirds)", "Marine Resources (including pinnipeds)") ~ "Pinnipeds",
    #And label studies that showed effects of "marine vertebrates" as "Marine Mammals (unspecified)" (as the studies were in areas with only marine mammals and birds)
    marine_megafauna_group == "Marine Vertebrates" ~ "Marine Mammals (unspecified)",
    TRUE ~ marine_megafauna_group)) %>% 
  #Split studies with multiple taxonomic groups into separate rows (this will double-count studies)
  separate_rows(megafauna_marginal_group, sep = ", ") %>% 
    mutate(megafauna_marginal_group = factor(megafauna_marginal_group, 
                                             levels = c("Cetaceans", "Pinnipeds", 
                                                        "Fissipeds", "Marine Mammals (unspecified)",
                                                        "Sea Turtles")))

 

ggplot(data=marginal_df, aes(x=decimal_latitude, fill = megafauna_marginal_group))+
  geom_histogram(bins=15,
                 breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90))+
  geom_vline(xintercept = seq(-90, 90, by = 15), color = "white")+  # Add vertical lines
  scale_x_continuous(breaks=c(-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90),
                     expand = c(0, 0))+
  scale_fill_manual(values = c("#440154FF", "#414487FF", 
                                 "#2A788EFF", "#22A884FF", "#7AD151FF"), 
                      labels = c("Cetaceans", "Pinnipeds", "Sea Otters",
                                 "Marine Mammals (unknown)", "Sea Turtles"))+
  coord_flip()+  # Flips the chart to be horizontal
  theme_classic() +
  theme(legend.position = "none")+
  labs(x = "Latitude", y= "# Studies")

ggsave("output/extra_plots/latitude_histogram.png", width = 2.5, height = 5, units = "in")
