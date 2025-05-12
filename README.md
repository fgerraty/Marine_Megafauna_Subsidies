# Historical and potential future importance of marine megafauna subsidies to terrestrial ecosystems

**FD Gerraty**, C Braman, J Dugan, K Elder, K Emery, B Halpern, W Heady, E Hiroyasu, G Lewin, E Nielsen, R Oliver, M Reynolds, A Wegmann, R Williams, R Wynn-Grant, H Young, Z Zilz

Marine megafauna connect land and sea by serving as large, calorically-rich food sources for terrestrial consumers and by transferring marine-derived nutrients onto land as eggs, placenta, and excreta. In this project, we review the role of marine megafauna - particularly marine mammals and sea turtles - as connectors of marine and terrestrial ecosystems along global coastlines. We compile published literature to describe the diversity of terrestrial consumers that exploit marine megafauna as a food source, as well as descriptions of documented ecological consequences resulting from megafauna-mediated nutrient subsidies from marine to terrestrial ecosystems. Here, we provide an overview of the datasets and scripts associated with this repository.

------------------------------------------------------------------------

There are two primary datasets associated with this repository:

1.  **Marine Megafauna Consumers:** All of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods). The cleaned dataset is accessible at [`data/processed/consumers.csv`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/consumers.csv). See [`data/README.md`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/README.md) for data dictionary and additional details.

2.  **Marine Megafauna Subsidies:** All of the case studies captured in our synthetic literature review that documented an ecological consequence in terrestrial ecosystems arising from (1) marine megafauna consumption by terrestrial consumers, (2) marine megafauna vectored nutrient subsidies to terrestrial ecosystems, or (3) indirect effects of marine megafauna. The cleaned dataset is accessible at [`data/processed/subsidies.csv`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/subsidies.csv). See [`data/README.md`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/README.md) for data dictionary and additional details.

There is one additional dataset associated with this repository, "Marine Megafauna Abundance" ([`data/processed/abundance.csv`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/abundance.csv)) that is derived from [Lotze and Worm (2009)](https://doi.org/10.1016/j.tree.2008.12.004) and includes historical and recent abundance estimates of marine mammal and sea turtle populations. See [`data/README.md`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/README.md) for data dictionary and additional details.

------------------------------------------------------------------------

There are four primary R scripts required to run all console and data preparation, data cleaning, analysis, and visualization steps:

-   **00_Packages.R** loads every package that is needed in following scripts. After running this script, all following scripts can be run independently.

-   **01_Data_Clean.R** cleans and summarizes raw data files. It also calculates values and summaries presented in the manuscript main text.

-   **02_Consumers.R** generates the sankey/alluvial plots in Figure 2.

-   **03_Map.R** generates the maps and histograms in Figure 3.

-   **04_Abundance.R** generates Figure 4.

![](output/extra_plots/analysis_pipeline.png)

------------------------------------------------------------------------
