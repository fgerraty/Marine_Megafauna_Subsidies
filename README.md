# Historical and potential future importance of marine megafauna subsidies to terrestrial ecosystems

*FD Gerraty, et al. (In Prep)*

We are assessing the historical, contemporary, and potential future importance of marine megafauna subsidies to terrestrial ecosystems. Marine megafauna subsidies occur when marine megafauna serve as a food source for terrestrial consumers, vector marine-derived nutrients into terrestrial ecosystems, or mediate the transfer of nutrients from marine to terrestrial ecosystems via indirect pathways. Here, we provide an overview of the datasets and scripts associated with this repository.

------------------------------------------------------------------------

There are two primary datasets associated with this repository:

1.  **Marine Megafauna Consumers:** All of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods). The cleaned dataset is accessible at [`data/processed/consumers.csv`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/consumers.csv). See [`data/README.md`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/README.md) for data dictionary and additional details.

2.  **Marine Megafauna Subsidies:** All of the case studies captured in our synthetic literature review that documented an ecological consequence in terrestrial ecosystems arising from (1) marine megafauna consumption by terrestrial consumers, (2) marine megafauna vectored nutrient subsidies to terrestrial ecosystems, or (3) indirect effects of marine megafauna. The cleaned dataset is accessible at [`data/processed/subsidies.csv`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/subsidies.csv). See [`data/README.md`](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/README.md) for data dictionary and additional details.

------------------------------------------------------------------------

There are four primary R scripts required to run all console and data preparation, data cleaning, analysis, and visualization steps:

-   **00_Packages.R** loads every package that is needed in following scripts. After running this script, all following scripts can be run independently.

-   **01_Data_Clean.R** cleans and summarizes raw data files.

-   **02_Data_Summary.R** summarizes processed data files and calculates values that are presented in Figure 1B.

-   **03_Consumers.R** generates the sankey/alluvial plots in Figure 2.

-   **04_Map.R** generates the maps and histograms in Figure 3.

![](output/extra_plots/analysis_pipeline.png)
