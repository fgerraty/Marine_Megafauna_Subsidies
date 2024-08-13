# Historical and potential future importance of marine megafauna subsidies to terrestrial ecosystems

*FD Gerraty, et al. (In Prep)*

We are assessing the historical, contemporary, and potential future importance of marine megafauna as global drivers of marine-to-terrestrial nutrient transfer. Here, we provide an overview of the datasets and scripts associated with this repository.

------------------------------------------------------------------------

There are two primary datasets associated with this repository:

1.  **Marine Megafauna Consumers:** All of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods). The cleaned dataset is accessible at `data/processed/consumers.csv`. See `data/README.md` for data dictionary and additional details.

2.  **Marine Megafauna Subsidies:** All of the case studies captured in our synthetic literature review that documented an ecological consequence in terrestrial ecosystems arising from (1) marine megafauna consumption by terrestrial consumers, (2) marine megafauna vectored nutrient subsidies to terrestrial ecosystems, or (3) indirect effects of marine megafauna. The cleaned dataset is accessible at `data/processed/subsidies.csv`. See `data/README.md` for data dictionary and additional details.

------------------------------------------------------------------------

There are X primary R scripts required to run all console and data preparation, data cleaning, analysis, and visualization steps:

-   **00_Packages.R** loads every package that is needed in following scripts. After running this script, all following scripts can be run independently.

-   **01_Data_Clean.R** cleans and summarizes raw data files.

-   **02_Data_Summary.R** summarizes processed data files and calculates values that are presented in Figure 1B.

-   **03_Consumers.R** generates the sankey/alluvial plots in Figure 2.

-   **04_Map.R** generates the maps and histograms in Figure 3.

------------------------------------------------------------------------

**Notes to Collaborators:**

-   Clone (don't fork) the github repo to collaborate.

-   Annotate your code!

-   Please code using tidyverse packages, following [tidy design principles](https://design.tidyverse.org/).

-   My style for naming things is generally:

    -   Scripts: Number_Name.R with capital letters (sorry!) and an underline separating words (e.g. 01_Data_Clean.R)

    -   Objects: lowercase words separated by an underline (e.g. marine_megafauna_subsidies)

-   I output all non-final plots to the folder output/extra_plots and then, once they are combined and arranged in illustrator, the final figure is output into the main_figures folder. If no tweaks in illustrator need to be made, we will save the file directly into the main_figures folder. Figures for the supplemental will get output to the supplemental_figures folder or to the extra_plots folder if they need to be tweaked in illustrator.

-   Do not hesitate to ask questions if you wanna help out!
