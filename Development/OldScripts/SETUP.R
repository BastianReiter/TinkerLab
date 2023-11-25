

################################################################################
#------------------------------------------------------------------------------#
#   HIVCAre: SETUP                                                             #
#------------------------------------------------------------------------------#
################################################################################


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set Project Root Directory for Path Management using the "here" package
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#here::i_am()


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Initialize renv for dependency management, only necessary at first run of project at development time
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#renv::init()


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Call Restore-function ensures use of project-specific R and package versions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#renv::restore()


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Attaching namespaces / packages at run time
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#install.packages("pacman")
#install.packages("tidytable")

vc_Packages <- c("censored",          # survival analysis in tidymodels
                 "colorspace",
                 "comorbidity",
                 "DiagrammeR",
                 "dplyr",
                 "encryptr",
                 "fontawesome",
                 "forcats",
                 "ggpattern",
                 "ggplot2",
                 "ggsankey",
                 "ggstatsplot",
                 "gt",
                 "gtExtras",
                 "gtsummary",
                 "here",
                 #"ICD10gm",
                 "lubridate",
                 "MatchIt",           # Matching tools
                 "parsnip",           # part of tidymodels
                 "pointblank",
                 "purrr",
                 "readr",
                 "readxl",
                 "rlang",
                 "scales",
                 "sf",                # Spatial analysis with simple features
                 "showtext",
                 "stringr",
                 "survival",
                 "survminer",
                 "svglite",
                 "sysfonts",
                 "tibble",
                 "tidyr")

pacman::p_load(vc_Packages, character.only = TRUE)



#lapply(vc_Packages, install.packages, character.only=TRUE)
#lapply(vc_Packages, library, character.only=TRUE)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# During Development, Call renv::snapshot() after adding or changing Packages 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#renv::snapshot()


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate private and public keys for file encryption (at development time)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#encryptr::genkeys()



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Project-specific Preferences
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source(here("Scripts/Preferences.R"))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Auxiliary Functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source(here("Scripts/Auxiliary.R"))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load Meta Data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source(here("Scripts/LoadMetaData.R"))

#   ==>  Major Resulting Objects:
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   df_Meta_Departments
#   df_Meta_DischargeReasons
#   df_Meta_ICD10CancerGrouping
#   df_Meta_ICD10Catalog
#   df_Meta_ICDHIVDiseases
#   df_Meta_ICDHIVStatus



