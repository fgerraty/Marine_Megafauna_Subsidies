##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 03: Subsidy Map #################################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------

subsidies <- read_csv("data/processed/subsidies.csv") %>% 
  drop_na(decimal_latitude)

subsidies_sf <- st_as_sf(subsidies, 
                         coords = c("decimal_longitude", "decimal_latitude"), 
                         crs = 4326) %>% 
  st_transform(crs = st_crs('ESRI:54030'))


# PART 2: Generate Map ---------------------------------------------------

world <- ne_countries(scale = "medium", returnclass = "sf")

ggplot() +
  geom_sf(data = world, color="transparent", fill = "grey70")+
  geom_sf(data = subsidies_sf, aes(fill=marine_megafauna_group),
             size = 3,
             color= "black",
             pch=21)+
  coord_sf(crs = st_crs('ESRI:54030'))+
  theme_minimal()

