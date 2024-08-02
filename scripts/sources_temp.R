library(tidyverse)
library(janitor)

Marine_Megafauna_Subsidies <- read_csv("data/raw/Marine_Megafauna_Subsidies.csv") %>% 
  clean_names() %>% 
  filter(type_of_marine_megafauna_subsidy != "Marine Mammal Vectored") %>% 
  filter(type_of_marine_megafauna_subsidy != "Marine Megafauna Vectored") %>% 
  filter(type_of_marine_megafauna_subsidy != "None")
  
Marine_Megafauna_Consumers <- read_csv("data/raw/Marine_Megafauna_Consumers.csv")


sources_1 <- Marine_Megafauna_Subsidies[,15:17]

sources_2 <- Marine_Megafauna_Consumers[,15:19]
sources_3 <- Marine_Megafauna_Consumers[,20:24]
sources_4 <- Marine_Megafauna_Consumers[,25:29]

colnames(sources_2) <- colnames(sources_3) <- colnames(sources_4) <- c("type", "kind", "title", "authors", "link")

combined_df <- bind_rows(sources_2, sources_3, sources_4) %>% 
  filter(type %in% c("Peer-reviewed article", "Peer-reviewed", "peer-review", "Peer-reviewed article article")) %>% 
  select(3:5)

colnames(sources_1) <- c("title", "authors", "link")

all_papers <- bind_rows(sources_1, combined_df) %>% 
  distinct()
  
write_csv(all_papers, "output/all_papers.csv")




coastal_consumers <- read_excel("data/raw/coastal_consumers_literature_search_data (1).xlsx", 
                                                          sheet = "2024_subsidy_data") %>% 
  clean_names()

length(unique(coastal_consumers$source_title))



title_1 <- data.frame(coastal_consumers$source_title)%>% 
  rename(title=coastal_consumers.source_title) %>% 
  distinct()
title_2 <- data.frame(all_papers$title) %>% 
  rename(title=all_papers.title)

common_cells <- title_1 %>%
  inner_join(title_2, by="title")


all_papers <- all_papers %>% 
  filter(! title%in%common_cells$title)
