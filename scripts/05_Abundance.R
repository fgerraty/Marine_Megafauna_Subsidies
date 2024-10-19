##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 05: Megafauna Abundance Plots  ##################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------

abundance <- read_csv("data/processed/abundance.csv") 

# PART 2: Prepara data for plots ---------------------------------------

df1 <- abundance %>% 
  #Select relevant columns 
  select(species_group, all_species_percent_decline_then_to_low, percent_decline_then_to_now) %>% 
  #Rename columns to be more tidy
  rename(low = all_species_percent_decline_then_to_low, 
         now = percent_decline_then_to_now) %>% 
  #Combine sea otters and sirenian records
  mutate(species_group = if_else(species_group %in% c("Otters", "Sirenia"), "Fissipeds and Sirenians", species_group)) %>% 
  #Pivot longer for plotting (turn time point into a variable (low or now))
  pivot_longer(cols = c(low, now), 
               names_to = "period", values_to = "percent_decline") %>% 
  group_by(species_group, period) %>% 
  summarise(mean = mean(percent_decline), 
            se = sd(percent_decline, na.rm = TRUE) / sqrt(n()),
            .groups = "drop")
  


ggplot()+
  
  #First we are going to create the first layer = lowest estimated abundance / greatest decline. 

  #Bar plot (layer 1)
  geom_bar(data = filter(df1, period == "low"), 
           aes(x=species_group, y=mean),
           stat = "identity",
           fill = "grey65")+
  #Errorbars (layer 1)
  geom_errorbar(data = filter(df1, period == "low"), 
                aes(x=species_group, ymin = mean-se, ymax = mean+se),
                color = "grey50",
                width = .25)+
  
  #Next, we are going to create the second layer = current/recent estimated abundance
  
  #Bar plot (layer 2)
  geom_bar(data = filter(df1, period == "now"), 
           aes(x=species_group, y=mean),
           stat = "identity",
           fill = "grey45")+
  #Errorbars (layer 2)
  geom_errorbar(data = filter(df1, period == "now"), 
                aes(x=species_group, ymin = mean-se, ymax = mean+se),
                color = "grey30",
                width = .25)+
  
  
  
  coord_flip()+
  theme_classic()+
  labs(x="", y="Percent decline from historical baseline")
  
  
# Plot 2 ----------------------------------------


df2 <- abundance %>% 
  select(record_lotze_worm, species_group, percent_left_low, percent_left_now) %>% 
  #Combine sea otters and sirenian records
  mutate(species_group = if_else(species_group %in% c("Otters", "Sirenia"), "Fissipeds and Sirenians", species_group)) %>% 
  #Rename columns to be more tidy
  rename(low = percent_left_low, 
         now = percent_left_now) %>% 
  pivot_longer(cols = c(low, now), 
               values_to = "percent_left", names_to="period") %>% 
  mutate(period = factor(period, levels = c("low", "now")))

  


ggplot(df2, mapping = aes(x=period, y=percent_left))+
  geom_path(aes(group = record_lotze_worm, color=species_group),
            linewidth = 0.4, alpha = 0.3, 
            position = position_jitter(width = 0.05, seed = 999))+
  geom_point(aes(color=species_group), alpha = .3, shape = 16,
             position = position_jitter(width = 0.05, seed = 999))+
  theme_classic()+
  stat_summary(geom = "pointrange", fun.data = "mean_cl_boot",
               color = "black")

  


#Tweaking

df3 <- abundance %>% 
  select(record_lotze_worm, species_group, percent_left_low, percent_left_now) %>% 
  #Combine sea otters and sirenian records
  mutate(species_group = if_else(species_group %in% c("Otters", "Sirenia"), "Fissipeds and Sirenians", species_group),
         baseline = 100) %>% 
  #Rename columns to be more tidy
  rename(low = percent_left_low, 
         now = percent_left_now) %>% 
  pivot_longer(cols = c(baseline, low, now), 
               values_to = "percent_left", names_to="period") %>% 
  mutate(period = factor(period, levels = c("baseline", "low", "now")))




ggplot(df3, mapping = aes(x=period, y=percent_left))+
  geom_path(aes(group = record_lotze_worm, color=species_group),
            linewidth = 0.4, alpha = 0.3, 
            position = position_jitter(width = 0.05, seed = 999))+
  geom_point(aes(color=species_group), alpha = .3, shape = 16,
             position = position_jitter(width = 0.05, seed = 999))+
  theme_classic()+
  stat_summary(geom = "pointrange", fun.data = "mean_cl_boot",
               color = "black")


