# Data Dictionary: Historical and potential future importance of marine megafauna subsidies to terrestrial ecosystems

*FD Gerraty, et al. (In Prep)*

------------------------------------------------------------------------

#### Folder ["raw"](https://github.com/fgerraty/Marine_Megafauna_Subsidies/tree/main/data/raw) houses the following data files

-   [**Marine_Megafauna_Consumers.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/raw/Marine_Megafauna_Consumers.csv) **-** All of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods).

    **Columns:**

    -   **Marine Megafauna Group** - category of marine megafauna ("Cetaceans", "Pinnipeds", "Fissipeds", "Sirenians", or "Sea Turtles")

    -   **Marine Megafauna Common Name** - common name of marine megafauna species (or common name of lowest possible taxonomic level based on source description)

    -   **Marine Megafauna Species** - scientific name of marine megafauna species (when available from data source)

    -   **Consumer Group** - categorical taxonomic grouping of consumer species (see categories presented in Figure 2A)

    -   **Consumer Class -** taxonomic class of consumer species

    -   **Consumer Family** - taxonomic family of consumer species

    -   **Consumer Common Name** - common name of terrestrial consumer species

    -   **Consumer Species** - scientific (latin) name of terrestrial consumer species

    -   **Scavenging** - TRUE/FALSE. TRUE indicates that the terrestrial consumer species was documented scavenging marine megafauna carrion by sources captured in our literature review. Note that consumers only documented consuming marine megafauna placentae, excreta, and/or eggs would not be flagged as TRUE because there are additional columns for these interaction types.

    -   **Predation** - TRUE/FALSE. TRUE indicates that the terrestrial consumer species was documented hunting marine megafauna (including juveniles, not including eggs; including parasitism) by sources captured in our literature review.

    -   **Consuming Placenta** - TRUE/FALSE. TRUE indicates that the terrestrial consumer species was documented consuming marine megafauna placentae by sources captured in our literature review.

    -   **Consuming Excreta** - TRUE/FALSE. TRUE indicates that the terrestrial consumer species was documented consuming marine megafauna excreta (e.g. feces) by sources captured in our literature review.

    -   **Consuming Eggs** - TRUE/FALSE. TRUE indicates that the terrestrial consumer species was documented consuming marine megafauna eggs by sources captured in our literature review.

    -   **Interaction Type Unknown** - TRUE/FALSE. TRUE indicates that the consumption mechanism (i.e. pathways described above) was not documented by sources captured in our literature review. This was typically the case for indirect evidence of consumption such as analysis of consumer tissues (e.g. stable isotope analysis), feces (e.g. fecal DNA metabarcoding), or investigation of prey remains den sites.

    -   **Notes**

    -   **Source 1 Type** - Type of source (e.g. Peer-reviewed article, Book, Report, etc.)

    -   **Source 1 Title** - Title of source

    -   **Source 1 Authors**

    -   **Source 1 Link** - DOI link when available.

    -   **Source 2 Type** - Type of source (e.g. Peer-reviewed article, Book, Report, etc.)

    -   **Source 2 Title** - Title of source

    -   **Source 2 Authors**

    -   **Source 2 Link** - DOI link when available.

    -   **Source 3 Type** - Type of source (e.g. Peer-reviewed article, Book, Report, etc.)

    -   **Source 3 Title** - Title of source

    -   **Source 3 Authors**

    -   **Source 3 Link** - DOI link when available.

-   [**Marine_Megafauna_Subsidies.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/raw/Marine_Megafauna_Subsidies.csv) **-** All of the case studies captured in our synthetic literature review that documented an ecological consequence in terrestrial ecosystems arising from (1) marine megafauna consumption by terrestrial consumers, (2) marine megafauna vectored nutrient subsidies to terrestrial ecosystems, or (3) indirect effects of marine megafauna.

    **Columns:**

    -   **Type of Marine Megafauna Subsidy** - (Marine Megafauna as Food, Marine Megafauna Vectored, Indirect Effects)

    -   **Interaction Type** - type of consumer-resource interaction (e.g. Predation, Scavenging, Consuming eggs, etc.) when applicable.

    -   **Type of Ecological Effect** - category of ecological effect elicited by marine megafauna subsidies. Categories include "Consumer health", "Consumer behavior", "Consumer abundance", "Community- and ecosystem-level", and "Other".

    -   **Marine Megafauna Group** - category of marine megafauna ("Cetaceans", "Pinnipeds", "Fissipeds", "Sirenians", or "Sea Turtles")

    -   **Marine Megafauna Common Name** - common name of marine megafauna species (or common name of lowest possible taxonomic level based on source description), when applicable.

    -   **Marine Megafauna Species** - scientific name of marine megafauna species, when applicable and available from data source.

    -   **Consumer Species Common Name** - common name of terrestrial consumer species, when applicable.

    -   **Consumer Species** - scientific name of terrestrial consumer species, when applicable.

    -   **Description of Ecological Effect** - 1-3 sentence description of ecological effects in terrestrial ecosystems elicited by marine megafauna subsidies.

    -   **Notes on Methods**

    -   **Country**

    -   **State/Region** - finer scale geographic description.

    -   **Decimal Latitude**

    -   **Decimal Longitude**

    -   **Source** - Title of source

    -   **Authors** - Source authors

    -   **Link** - DOI link when available.

    -   **Notes**

-   [**Megafauna_Abundance.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/raw/Megafauna_Abundance.csv) **-** The supplemental record table from [Lotze and Worm (2009)](https://doi.org/10.1016/j.tree.2008.12.004) filtered to only include records of marine mammals and sea turtles. See Box 3 in [Lotze and Worm (2009)](https://doi.org/10.1016/j.tree.2008.12.004) for a detailed description of data collection and analysis.

    **Columns:**

    -   **Record_Lotze_Worm** - record ID from the supplemental record table in [Lotze and Worm (2009)](https://doi.org/10.1016/j.tree.2008.12.004).

    -   **Species Group -** Taxonomic group

    -   **Species Detail -** Species name

    -   **Region -** Region of the source study

    -   **Ocean Habitat -** Ocean habitat of the megafauna species

    -   **Discipline -** Discipline of source study

    -   **Analytical method -** Analytical method of source study

    -   **Metric used (unit) -** Abundance metric (e.g., biomass, number)

    -   **Data detail -** Additional details of source data

    -   **Time period Then to Now -** Time frame of the study

    -   **Low year -** Year of lowest abundance. If this is empty then the low
        point is equal to the most recent record.

    -   **Then unit -** Abundance estimates for the beginning of the data series.

    -   **Low unit -** Abundance estimates for the low point of the data series. If this is empty then the low point is equal to the most recent record.

    -   **Now unit -** Most recent abundance estimate for the data series.

    -   **All species % Decline Then to Low -** Percent decline from historical baseline to low record.

    -   **% Decline Then to Now -** Percent decline from historical baseline to most recent record.

    -   **% Left Low -** Percent left of historical baseline at low record

    -   **% Left Now -** Percent left of historical baseline at most recent record

    -   **Recovered only % Left Low -** Percent left of historical baseline at low record (only for recovered species)

    -   **Recovered only % Left Now -** Percent left of historical baseline at most recent record (only for recovered species)

    -   **Ref_No_Lotze_Worm -** Record reference number from Lotze and Worm 2009.

#### Folder ["processed"](https://github.com/fgerraty/Marine_Megafauna_Subsidies/tree/main/data/processed) houses the following data files

-   [**consumers.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/consumers.csv) **-** A complete, clean version of the *Marine_Megafauna_Consumers.csv* raw data file, which includes all of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods).

    Columns in this file are the same as *Marine_Megafauna_Consumers.csv* except in this version they are all lowercase, with words separated by underlines (e.g. "Marine Megafauna Group" is now "marine_megafauna_group")

-   [**filtered_consumers.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/filtered_consumers.csv) **-** A second version of *consumers.csv*, except the rows in this file have been filtered to remove potentially duplicated combinations of marine megafauna species and terrestrial consumer species.

    Potential duplicates arise when data sources do not report taxonomic levels to species level. In these cases, we removed the rows with lower taxonomic resolution. For example, if one article reported a coyote (*Canis latrans*) scavenging a whale carcass (species not reported) and another article reported a coyote scavenging a humpback whale (*Megaptera novaeangliae*) carcass, the row in which the whale was not identified to species level would be removed in this file.

-   [**subsidies.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/subsidies.csv) **-** A complete, clean version of the *Marine_Megafauna_Subsidies.csv* raw data file, which includes all of the case studies captured in our synthetic literature review that documented an ecological consequence in terrestrial ecosystems arising from (1) marine megafauna consumption by terrestrial consumers, (2) marine megafauna vectored nutrient subsidies to terrestrial ecosystems, or (3) indirect effects of marine megafauna.

    Columns in this file are the same as *Marine_Megafauna_Subsidies.csv* except in this version they are all lowercase, with words separated by underlines (e.g. "Marine Megafauna Group" is now "marine_megafauna_group")

-   [**abundance.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/abundance.csv) - A clean version of the *Megafauna_Abundance.csv* raw data file derived from Lotze and Worm (2009). Columns in this file are the same as *Megafauna_Abundance.csv* except in this version they are all lowercase, with words separated by underlines.
