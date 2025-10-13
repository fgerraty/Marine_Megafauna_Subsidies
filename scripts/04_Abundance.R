##########################################################################
# Marine Megafauna Subsidies to Terrestrial Ecosystems ###################
# Gerraty et al. (frankiegerraty@gmail.com; fgerraty@ucsc.edu) ###########
##########################################################################
# Script 05: Megafauna Abundance Plots  ##################################
#-------------------------------------------------------------------------

# PART 1: Import Data ----------------------------------------------------

abundance <- read_csv("data/processed/abundance.csv") 
ESA_abundance <- read_csv("data/processed/ESA_abundance.csv",
                          col_types = cols(
                            growth_rate_percent = col_character()))

# PART 2: Abundance Plot Panel A -----------------------------------------

A_df <- abundance %>% 
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


#Plot panel A

panel_A <- ggplot(A_df, aes(x=species_group, y=mean, fill = period))+
  geom_bar(stat="identity", position = "dodge")+  
  geom_errorbar(aes(ymin = mean-se, ymax = mean+se), 
                position = position_dodge(width = 1), 
                width = .2, color = "grey20")+
#  coord_flip()+
  scale_x_discrete(labels = c("Cetaceans", "Pinnipeds","Sea otters\nand sirenians","Sea turtles"))+
  scale_y_continuous(breaks = c(0,10,20,30,40))+
  scale_fill_manual(values = c("grey70", "grey40"), labels = c("Lowest abundance", "Most recent\nabundance"))+
  theme_few()+
  labs(x="", y="Percent of historical baseline abundance", fill = "")+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5),
   #     legend.position = "none")
  )
panel_A

#Make legend for panel B ----

legend_A <- get_legend(panel_A) %>% 
            as_ggplot()

legend_A

ggsave("output/extra_plots/abundance_A_legend.png", legend_A, 
       width = 3, height = 3, units = "in")

panel_A <- panel_A+
  theme(legend.position = "none")

panel_A


ggsave("output/extra_plots/abundance_A.png", panel_A, 
       width = 5, height = 4, units = "in")


# PART 2: Abundance Plot Panel B-E -----------------------------------------

ESA_marine_megafauna <- ESA_abundance %>% 
  clean_names %>% 
  filter(group %in% c("Marine mammal", "Reptile")) %>% 
  filter(!common_name == "Polar bear") %>% 
  mutate(taxa = if_else(taxa %in% c("Carnivora", "Sirenia"), 
                        "Sea otters and sirenians", taxa)) %>% 
  filter(time>1967) %>% 
  drop_na(estimate) %>% 
  group_by(spp_id, pop_location) %>% 
  mutate(percent_of_max = estimate/max(estimate),
         observation_count = n(),
         spp_id = factor(spp_id)) %>% 
  filter(observation_count >1) %>% 
  select(spp_id, group, taxa, common_name, scientific_name, pop_location, time, estimate, percent_of_max)

#Tally number of species and populations for each taxonomic group (Note that this is also accounting for subspecies, which have unique species names in the dataframe)
ESA_marine_megafauna %>% 
  select(taxa, scientific_name, spp_id, pop_location) %>% 
  unique() %>% 
  group_by(taxa) %>% 
  summarize(n_records = n(),
            n_species = length(unique(scientific_name)))




# Cetacean GAM -----------------------------------------------------------------

set.seed(99)

#Fit GAM
cetacean_gam <- gam(
  percent_of_max ~ s(time, k=-1) + #Year as smooth predictor
    s(spp_id, bs = "re"), #Site as a random effect
  data = filter(ESA_marine_megafauna, taxa == "Cetacean"),
  method = "REML") # Use restricted maximum likelihood for smoother estimation

summary(cetacean_gam)

# Interrogate GAM model
par(mfrow = c(2, 2)) # Set up plotting grid
gam.check(cetacean_gam)

plot(cetacean_gam, pages = 1, rug = TRUE, shade = TRUE)
plot(residuals(cetacean_gam) ~ filter(ESA_marine_megafauna, taxa == "Cetacean")$time)


smooth_coefs(cetacean_gam, "s(spp_id)")

#Identify the site_id with the median estimate, which we will use for predictions
print(smooth_estimates(cetacean_gam) %>% 
        filter(.smooth == "s(spp_id)") %>% 
        arrange(.estimate), 
      n=13)

#Since there are two center values (no median), we will choose the first one. spp_id = 4a

#Predict values from GAM for plotting
cetacean_gam_predictions <- data.frame(
  time = seq(1968, 2017, by = 0.25),
  spp_id = "22"
) %>% 
  mutate(
    fit = predict.gam(cetacean_gam, newdata = ., se.fit = TRUE)$fit,
    se = predict.gam(cetacean_gam, newdata = ., se.fit = TRUE)$se.fit,
    lower = fit - 1.96 * se,  #95% CI
    upper = fit + 1.96 * se)


# Pinniped GAM -----------------------------------------------------------------

set.seed(99) 

#Fit GAM
pinniped_gam <- gam(
  percent_of_max ~ s(time, k=-1) + #Year as smooth predictor
    s(spp_id, bs = "re"), #Site as a random effect
  data = filter(ESA_marine_megafauna, taxa == "Pinniped"),
  method = "REML") # Use restricted maximum likelihood for smoother estimation

summary(pinniped_gam)

# Interrogate GAM model
par(mfrow = c(2, 2)) # Set up plotting grid
gam.check(pinniped_gam)

plot(pinniped_gam, pages = 1, rug = TRUE, shade = TRUE)
plot(residuals(pinniped_gam) ~ filter(ESA_marine_megafauna, taxa == "Pinniped")$time)


smooth_coefs(pinniped_gam, "s(spp_id)")

#Identify the site_id with the median estimate, which we will use for predictions
smooth_estimates(pinniped_gam) %>% 
  filter(.smooth == "s(spp_id)") %>% 
  arrange(.estimate)


#Predict values from GAM for plotting
pinniped_gam_predictions <- data.frame(
  time = seq(1968, 2017, by = 0.25),
  spp_id = "108a"
) %>% 
  mutate(
    fit = predict.gam(pinniped_gam, newdata = ., se.fit = TRUE)$fit,
    se = predict.gam(pinniped_gam, newdata = ., se.fit = TRUE)$se.fit,
    lower = fit - 1.96 * se,  #95% CI
    upper = fit + 1.96 * se)

# Sea Otter + Sirenian GAM -----------------------------------------------------

set.seed(99)

#Fit GAM
otter_sirenian_gam <- gam(
  percent_of_max ~ s(time, k=-1) + #Year as smooth predictor
    s(spp_id, bs = "re"), #Site as a random effect
  data = filter(ESA_marine_megafauna, taxa == "Sea otters and sirenians"),
  method = "REML") # Use restricted maximum likelihood for smoother estimation

summary(otter_sirenian_gam)

# Interrogate GAM model
par(mfrow = c(2, 2)) # Set up plotting grid
gam.check(otter_sirenian_gam)

plot(otter_sirenian_gam, pages = 1, rug = TRUE, shade = TRUE)
plot(residuals(otter_sirenian_gam) ~ filter(ESA_marine_megafauna, taxa == "Sea otters and sirenians")$time)


smooth_coefs(otter_sirenian_gam, "s(spp_id)")

#Identify the site_id with the median estimate, which we will use for predictions
(smooth_estimates(otter_sirenian_gam) %>% 
    filter(.smooth == "s(spp_id)") %>% 
    filter(.estimate == median(.estimate)))$spp_id


#Predict values from GAM for plotting
otter_sirenian_gam_predictions <- data.frame(
  time = seq(1968, 2017, by = 0.25),
  spp_id = "107"
) %>% 
  mutate(
    fit = predict.gam(otter_sirenian_gam, newdata = ., se.fit = TRUE)$fit,
    se = predict.gam(otter_sirenian_gam, newdata = ., se.fit = TRUE)$se.fit,
    lower = fit - 1.96 * se,  #95% CI
    upper = fit + 1.96 * se)


#Sea turtle GAM ----------------------------------------------------------------

set.seed(99)

#Fit GAM
sea_turtle_gam <- gam(
  percent_of_max ~ s(time, k=-1) + #Year as smooth predictor
    s(spp_id, bs = "re"), #Site as a random effect
  data = filter(ESA_marine_megafauna, taxa == "Sea turtle"),
  method = "REML") # Use restricted maximum likelihood for smoother estimation

summary(sea_turtle_gam)

# Interrogate GAM model
par(mfrow = c(2, 2)) # Set up plotting grid
gam.check(sea_turtle_gam)

plot(sea_turtle_gam, pages = 1, rug = TRUE, shade = TRUE)
plot(residuals(sea_turtle_gam) ~ filter(ESA_marine_megafauna, taxa == "Sea turtle")$time)


smooth_coefs(sea_turtle_gam, "s(spp_id)")

#Identify the site_id with the median estimate, which we will use for predictions
(smooth_estimates(sea_turtle_gam) %>% 
    filter(.smooth == "s(spp_id)") %>% 
    filter(.estimate == median(.estimate)))$spp_id


#Predict values from GAM for plotting
sea_turtle_gam_predictions <- data.frame(
  time = seq(1968, 2017, by = 0.25),
  spp_id = "47a"
) %>% 
  mutate(
    fit = predict.gam(sea_turtle_gam, newdata = ., se.fit = TRUE)$fit,
    se = predict.gam(sea_turtle_gam, newdata = ., se.fit = TRUE)$se.fit,
    lower = fit - 1.96 * se,  #95% CI
    upper = fit + 1.96 * se)


################
# Plot GAMs ####
################

# Cetacean Plot ---------------------------------------------------------------

ESA_cetacean <- ggplot(data = filter(ESA_marine_megafauna, taxa == "Cetacean"), 
       aes(x=time))+
  geom_point(alpha = .4, pch = 16, color = "#440154FF", 
             aes(y=percent_of_max))+
  geom_line(data = cetacean_gam_predictions, aes(y=fit), 
            color = "#440154FF", linewidth = 1)+
  geom_ribbon(data = cetacean_gam_predictions, aes(ymin = lower, ymax = upper),
              fill = "#440154FF", alpha = 0.5)+
  labs(x="", y="")+
  scale_y_continuous(labels = c("0", "25", "50", "75", "100"))+
  theme_few()+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5),
        axis.text.x = element_blank())

ggsave("output/extra_plots/ESA_cetacean.png", ESA_cetacean, 
       width = 3, height = 2, units = "in", dpi = 600)

# Pinniped Plot ---------------------------------------------------------------

ESA_pinniped <- ggplot(data = filter(ESA_marine_megafauna, taxa == "Pinniped"), 
       aes(x=time))+
  geom_point(alpha = .4, pch = 16, color = "#414487FF", 
             aes(y=percent_of_max))+
  geom_line(data = pinniped_gam_predictions, aes(y=fit), 
            color = "#414487FF", linewidth = 1)+
  geom_ribbon(data = pinniped_gam_predictions, aes(ymin = lower, ymax = upper),
              fill = "#414487FF", alpha = 0.5)+
  labs(x="", y="")+
  coord_cartesian(ylim = c(0,1))+
  theme_few()+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5),
        axis.text.x = element_blank(),
        axis.text.y = element_blank())

ggsave("output/extra_plots/ESA_pinniped.png", ESA_pinniped, 
       width = 2.8, height = 2, units = "in", dpi = 600)

# Sea otter and sirenian plot --------------------------------------------------

ESA_otter_sirenian <- ggplot(data = filter(ESA_marine_megafauna, taxa == "Sea otters and sirenians"), 
       aes(x=time))+
  geom_point(alpha = .4, pch = 16, color = "#1d918c", 
             aes(y=percent_of_max))+
  geom_line(data = otter_sirenian_gam_predictions, aes(y=fit), 
            color = "#1d918c", linewidth = 1)+
  geom_ribbon(data = otter_sirenian_gam_predictions, aes(ymin = lower, ymax = upper),
              fill = "#1d918c", alpha = 0.5)+
  labs(x="Year", y="")+
  scale_y_continuous(breaks = c(0, .25, .5, .75, 1),
                     labels = c("0", "25", "50", "75", "100"))+
  coord_cartesian(ylim = c(0,1))+
  theme_few()+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5),
  )

ggsave("output/extra_plots/ESA_otter_sirenian.png", ESA_otter_sirenian, 
       width = 3, height = 2.2, units = "in")

# Sea turtle plot --------------------------------------------------------------

ESA_sea_turtle <- ggplot(data = filter(ESA_marine_megafauna, taxa == "Sea turtle"), 
       aes(x=time))+
  geom_point(alpha = .4, pch = 16, color = "#7AD151FF", 
             aes(y=percent_of_max))+
  geom_line(data = sea_turtle_gam_predictions, aes(y=fit), 
            color = "#7AD151FF", linewidth = 1)+
  geom_ribbon(data = sea_turtle_gam_predictions, aes(ymin = lower, ymax = upper),
              fill = "#7AD151FF", alpha = 0.6)+
  labs(x="Year", y="")+
  theme_few()+
  theme(panel.border = element_rect(colour = "black", fill=NA, linewidth=1.5),
        axis.text.y = element_blank())

ggsave("output/extra_plots/ESA_sea_turtle.png", ESA_sea_turtle, 
       width = 2.8, height = 2.2, units = "in")
