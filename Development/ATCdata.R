
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Compilation of ATC data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(dplyr)

# Get english data from 'atc' package
# devtools::install_github("jorainer/atc")

DataEnglish <- as.data.frame(atc::atc) %>%
                    filter(level == 5) %>%
                    select(key, name)

DataGerman <- readxl::read_excel(path = "C:/Users/Basti/Desktop/atcdata.xlsx",
                                 sheet = "Tabelle1")


ATCCodes <- DataGerman %>%
                left_join(DataEnglish, by = join_by(Code == key)) %>%
                setNames(c("ATCCode", "NameGerman", "NameEnglish"))



