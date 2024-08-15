# Data Dictionary: Historical and potential future importance of marine megafauna subsidies to terrestrial ecosystems

*FD Gerraty, et al. (In Prep)*

------------------------------------------------------------------------

#### Folder ["raw"](https://github.com/fgerraty/Marine_Megafauna_Subsidies/tree/main/data/raw) houses the following data files

-   [**Marine_Megafauna_Consumers.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/raw/Marine_Megafauna_Consumers.csv) **-** All of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods).

    **Columns:**

    -   **Marine Megafauna Group** - category of marine megafauna ("Cetaceans", "Pinnipeds", "Fissipeds", "Sirenians", or "Sea Turtles")

    -   **Marine Megafauna Common Name** - common name of marine megafauna species (or common name of lowest possible taxonomic level based on source description)

    -   **Marine Megafauna Species** - scientific name of marine megafauna species (when available from data source)

    -   **Consumer Class** - broad categorical taxonomic grouping of consumer species (see categories presented in Figure 2A)

    -   **Consumer Group** - finer scale categorical taxonomic grouping of consumer species

    -   **Consumer Common Name** - common name of terrestrial consumer species

    -   **Consumer Species** - scientific name of terrestrial consumer species

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

#### Folder ["processed"](https://github.com/fgerraty/Marine_Megafauna_Subsidies/tree/main/data/processed) houses the following data files

-   [**consumers.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/consumers.csv) **-** A complete, clean version of the *Marine_Megafauna_Consumers.csv* raw data file, which includes all of the terrestrial vertebrate consumers of marine megafauna captured in our synthetic literature review (see manuscript for review methods).

    Columns in this file are the same as *Marine_Megafauna_Consumers.csv* except in this version they are all lowercase, with words separated by underlines (e.g. "Marine Megafauna Group" is now "marine_megafauna_group")

-   [**filtered_consumers.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/filtered_consumers.csv) **-** A second version of *consumers.csv*, except the rows in this file have been filtered to remove potentially duplicated combinations of marine megafauna species and terrestrial consumer species.

    Potential duplicates arise when data sources do not report taxonomic levels to species level. In these cases, we removed the rows with lower taxonomic resolution. For example, if one article reported a coyote (*Canis latrans*) scavenging a whale carcass (species not reported) and another article reported a coyote scavenging a humpback whale (*Megaptera novaeangliae*) carcass, the row in which the whale was not identified to species level would be removed in this file.

-   [**subsidies.csv**](https://github.com/fgerraty/Marine_Megafauna_Subsidies/blob/main/data/processed/subsidies.csv) **-** A complete, clean version of the *Marine_Megafauna_Subsidies.csv* raw data file, which includes all of the case studies captured in our synthetic literature review that documented an ecological consequence in terrestrial ecosystems arising from (1) marine megafauna consumption by terrestrial consumers, (2) marine megafauna vectored nutrient subsidies to terrestrial ecosystems, or (3) indirect effects of marine megafauna.

    Columns in this file are the same as *Marine_Megafauna_Subsidies.csv* except in this version they are all lowercase, with words separated by underlines (e.g. "Marine Megafauna Group" is now "marine_megafauna_group")
