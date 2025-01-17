##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 05: Megafauna Abundance Plots  ##################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------

abundance <- read_csv("data/processed/abundance.csv") 

# PART 2: Abundance Plot Panel A -----------------------------------------

A_df <- abundance %>% 
  select(record_lotze_worm, species_group, percent_left_low, percent_left_now) %>% 
  #Combine sea otters and sirenian records
  mutate(species_group = if_else(species_group %in% c("Otters", "Sirenia"), "Fissipeds and Sirenians", species_group),
         baseline = 100) %>% 
  #Rename columns to be more tidy
  rename(low = percent_left_low, 
         now = percent_left_now) %>% 
  pivot_longer(cols = c(baseline, low, now), 
               values_to = "percent_left", names_to="period") %>% 
  mutate(period = factor(period, levels = c("baseline", "low", "now")),
         species_group = factor(species_group, levels = c("Whales", "Pinnipeds", "Fissipeds and Sirenians", "Sea turtles")))


panel_A <- ggplot(A_df, mapping = aes(x=period, y=percent_left))+
  geom_path(aes(group = record_lotze_worm),color="grey70",
            linewidth = 0.4, alpha = 0.3, 
            position = position_jitter(width = 0.1, seed = 999))+
  geom_point(color="grey70", alpha = .3, shape = 16,
             position = position_jitter(width = 0.1, seed = 999))+
  theme_few()+
  stat_summary(geom = "pointrange", 
               fun.data = "mean_cl_boot",
               color = "black",
               linewidth = 1)+
  scale_x_discrete(labels = c("Historical\nbaseline", "Lowest\nabundance", "Most recent\nabundance"), expand = c(0.1,0.1))+
  labs(x="", y="Percent of historical baseline abundance")+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5))

panel_A



ggsave("output/extra_plots/abundance_A.png", panel_A, 
       width = 5, height = 4, units = "in")

#Make the same figure with colored points

panel_A_color <- ggplot(A_df, mapping = aes(x=period, y=percent_left))+
  geom_path(aes(group = record_lotze_worm),color="grey70",
            linewidth = 0.4, alpha = 0.3, 
            position = position_jitter(width = 0.1, seed = 999))+
  geom_point(aes(color=species_group), alpha = .7, shape = 16,
             position = position_jitter(width = 0.1, seed = 999))+
  theme_few()+
  stat_summary(geom = "pointrange", 
               fun.data = "mean_cl_boot",
               color = "black",
               linewidth = 1)+
  scale_x_discrete(labels = c("Historical\nbaseline", "Lowest\nabundance", "Most recent\nabundance"), expand = c(0.1,0.1))+
  scale_color_manual(values = c("#440154FF", "#414487FF", "#22A884FF", "#7AD151FF"), labels = c("Whales", "Pinnipeds", "Sea otters and sirenians", "Sea turtles"))+
  labs(x="", y="Percent of historical baseline abundance", color = "Marine Megafauna Group")+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5))
panel_A_color

legend_A_color <- get_legend(panel_A_color) %>% 
  as_ggplot()

ggsave("output/extra_plots/legend_A_color.png", legend_A_color, 
       width = 2, height = 2, units = "in")

panel_A_color <- panel_A_color+
  theme(legend.position = "none")

ggsave("output/extra_plots/abundance_A_color.png", panel_A_color, 
       width = 5, height = 4, units = "in")



# PART 2: Abundance Plot Panel B -----------------------------------------

B_df <- abundance %>% 
  #Select relevant columns 
  select(species_group, percent_left_low, percent_left_now) %>% 
  #Rename columns to be more tidy
  rename(low = percent_left_low, 
         now = percent_left_now) %>% 
  #Combine sea otters and sirenian records
  mutate(species_group = if_else(species_group %in% c("Otters", "Sirenia"), "Fissipeds and sirenians", species_group),
         #Turn into factor for plotting
         species_group = factor(species_group, levels = c("Whales","Pinnipeds", "Fissipeds and sirenians","Sea turtles"))) %>% 
  #Pivot longer for plotting (turn time point into a variable (low or now))
  pivot_longer(cols = c(low, now), 
               names_to = "period", values_to = "percent_decline") %>% 
  group_by(species_group, period) %>% 
  summarise(mean = mean(percent_decline), 
            se = sd(percent_decline, na.rm = TRUE) / sqrt(n()),
            n = n(),
            .groups = "drop")


#Plot panel B

panel_B <- ggplot(B_df, aes(x=species_group, y=mean, fill = period))+
  geom_bar(stat="identity", position = "dodge")+  
  geom_errorbar(aes(ymin = mean-se, ymax = mean+se), 
                position = position_dodge(width = 1), 
                width = .2, color = "grey20")+
#  coord_flip()+
  scale_x_discrete(labels = c("Cetaceans", "Pinnipeds","Sea otters\nand sirenians","Sea turtles"))+
  scale_y_continuous(breaks = c(0,10,20,30,40))+
  scale_fill_manual(values = c("grey70", "grey40"), labels = c("Lowest abundance", "Most recent\nabundance"))+
  theme_few()+
  labs(x="", y="Percent of historical abundance", fill = "")+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5),
   #     legend.position = "none")
  )
panel_B

#Make legend for panel B ------------------------------------------------------

legend_B <- get_legend(panel_B) %>% 
            as_ggplot()

legend_B

ggsave("output/extra_plots/abundance_B_legend.png", legend_B, 
       width = 3, height = 3, units = "in")

panel_B <- panel_B+
  theme(legend.position = "none")

panel_B


ggsave("output/extra_plots/abundance_B.png", panel_B, 
       width = 5, height = 4, units = "in")



