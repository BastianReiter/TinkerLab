
#==============================================================================#
#------------------------------------------------------------------------------#
#   TinkerLab: Data Processing                                                 #
#------------------------------------------------------------------------------#
#==============================================================================#


library(dplyr)
library(purrr)
library(readxl)
library(stringr)
library(tidyr)
library(usethis)


#===============================================================================
# ATC Coding
#===============================================================================

Res.ATCCoding <- read_excel(path = "./Development/Data/TinkerLab_ATCCoding.xlsx",
                            sheet = "ATCData")

usethis::use_data(Res.ATCCoding, overwrite = TRUE)



#===============================================================================
# Cancer Coding
#===============================================================================

# Data on Cancer Grouping
#~~~~~~~~~~~~~~~~~~~~~~~~
Res.CancerGrouping <- read_excel(path = "./Development/Data/TinkerLab_CancerCoding.xlsx",
                                 sheet = "CancerGrouping")

# Save data in .rda-file and make it part of package
use_data(Res.CancerGrouping, overwrite = TRUE)


# Data on Cancer Surgery
#~~~~~~~~~~~~~~~~~~~~~~~
Res.CancerSurgery <- read_excel(path = "./Development/Data/TinkerLab_CancerCoding.xlsx",
                                sheet = "CancerSurgery")

# Save data in .rda-file and make it part of package
use_data(Res.CancerSurgery, overwrite = TRUE)


# Data on ICD-O-3 Morphology grouping
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Res.ICDOMorphology <- FullCodes      # see script "./Development/ICDOData.R"

use_data(Res.ICDOMorphology, overwrite = TRUE)



# Data on Systemic Therapy Regimen
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Res.SystemicTherapy.Regimens <- read_excel(path = "./Development/Data/TinkerLab_SystemicTherapy.xlsx",
                                           sheet = "Regimens",
                                           skip = 2)


# SubstanceNames <- Res.SystemicTherapy.Regimens %>%
#                       select(starts_with("Substance")) %>%
#                       unlist(use.names = FALSE) %>%
#                       unique()
#
# EligibleSubstanceNames <- dsCCPhos::Meta.Values %>%
#                               filter(Table == "SystemicTherapy",
#                                      FeatureName.Curated == "Substance") %>%
#                               pluck("Value.Raw")
#
# SubstanceNameCheck <- SubstanceNames[!(SubstanceNames %in% EligibleSubstanceNames)]
# SubstanceNameCheck


Res.SystemicTherapy.Regimens <- Res.SystemicTherapy.Regimens %>%
                                    select(Regimen,
                                           starts_with("Substance"),
                                           Criteria.ICD10Code,
                                           Criteria.ICD10Code.Short,
                                           Criteria.ICD10Code.SecondaryUse,
                                           Criteria.ICD10Code.Short.SecondaryUse,
                                           Criteria.ICDO.TopographyCode.Short,
                                           Criteria.ICDO.TopographyCode.Short.SecondaryUse,
                                           Criteria.ICDO.MorphologyHistologyCode,
                                           IsSingleAgentRegimen,
                                           ExpectedLOT,
                                           ExpectedTherapyContext) %>%
                                    mutate(IsLikelyFirstLine = case_when(ExpectedLOT %in% c("first-line", "first-line and later") ~ TRUE,
                                                                         !is.na(ExpectedLOT) ~ FALSE,
                                                                         .default = NA),
                                           IsLikelyLaterLine = case_when(ExpectedLOT == "second-line and later" ~ TRUE,
                                                                         .default = NA),
                                           IsLikelyCurativeIntention = case_when(str_detect(ExpectedTherapyContext, "curative-intent|induction|consolidation") ~ TRUE,
                                                                                 !is.na(ExpectedTherapyContext) ~ FALSE,
                                                                                 .default = NA),
                                           IsUsedInPalliativeIntention = case_when(str_detect(ExpectedTherapyContext, "palliative") ~ TRUE,
                                                                                   !is.na(ExpectedTherapyContext) ~ FALSE,
                                                                                   .default = NA),
                                           IsUsedInNeoadjuvant = case_when(str_detect(ExpectedTherapyContext, "neoadjuvant") ~ TRUE,
                                                                           !is.na(ExpectedTherapyContext) ~ FALSE,
                                                                           .default = NA),
                                           IsUsedInAdjuvant = case_when(str_detect(ExpectedTherapyContext, "adjuvant") & !str_detect(ExpectedTherapyContext, "neoadjuvant") ~ TRUE,
                                                                        !is.na(ExpectedTherapyContext) ~ FALSE,
                                                                        .default = NA),
                                           IsUsedInSalvage = case_when(str_detect(ExpectedTherapyContext, "salvage") ~ TRUE,
                                                                        .default = NA),
                                           IsUsedInMaintenance = case_when(str_detect(ExpectedTherapyContext, "maintenance|long-term endocrine") ~ TRUE,
                                                                           .default = NA),
                                           IsUsedInChemoradiotherapy = case_when(str_detect(ExpectedTherapyContext, "chemoradiotherapy") ~ TRUE,
                                                                                .default = NA))

usethis::use_data(Res.SystemicTherapy.Regimens, overwrite = TRUE)


#===============================================================================
# HIV Coding
#===============================================================================

Res.HIVCoding.Status <- read_excel(path = "./Development/Data/TinkerLab_HIVCoding.xlsx",
                                   sheet = "HIVStatus")

use_data(Res.HIVCoding.Status, overwrite = TRUE)


Res.HIVCoding.Diseases <- read_excel(path = "./Development/Data/TinkerLab_HIVCoding.xlsx",
                                     sheet = "HIVDiseases")

use_data(Res.HIVCoding.Diseases, overwrite = TRUE)



#===============================================================================
# OPS coding
#===============================================================================

Res.OPSCodes <- read_excel(path = "./Development/Data/TinkerLab_OPSCoding.xlsx",
                           sheet = "OPSCodes")

use_data(OPSCodes, overwrite = TRUE)



#===============================================================================
# Working with P21 data
#===============================================================================

FilePath <- "Development/Data/TinkerLab_P21.xlsx"

Res.P21.AdmissionCauses <- read_excel(path = FilePath,
                                      sheet = "AdmissionCauses")

use_data(Res.P21.AdmissionCauses, overwrite = TRUE)


Res.P21.DischargeReasons <- read_excel(path = FilePath,
                                       sheet = "DischargeReasons")

use_data(Res.P21.DischargeReasons, overwrite = TRUE)


Res.P21.Departments <- read_excel(path = FilePath,
                                  sheet = "Departments")

use_data(Res.P21.Departments, overwrite = TRUE)



#===============================================================================
# Keyboard Neighborhoods
#===============================================================================

KeyboardNeighbors.German <- list( q = c("w", "a"),
                                  w = c("e", "s", "a", "q"),
                                  e = c("r", "d", "s", "w"),
                                  r = c("t", "f", "d", "e"),
                                  t = c("z", "g", "f", "r"),
                                  z = c("u", "h", "g", "t"),
                                  u = c("i", "j", "h", "z"),
                                  i = c("o", "k", "j", "u"),
                                  o = c("p", "l", "k", "i"),
                                  p = c("ü", "ö", "l", "o"),
                                  ü = c("ä", "ö", "p"),
                                  a = c("q", "w", "s", "y"),
                                  s = c("w", "e", "d", "x", "y", "a"),
                                  d = c("e", "r", "f", "c", "x", "s"),
                                  f = c("r", "t", "g", "v", "c", "d"),
                                  g = c("t", "z", "h", "b", "v", "f"),
                                  h = c("z", "u", "j", "n", "b", "g"),
                                  j = c("u", "i", "k", "m", "n", "h"),
                                  k = c("i", "o", "l", "m", "j"),
                                  l = c("o", "p", "ö", "k"),
                                  ö = c("p", "ü", "ä", "l"),
                                  ä = c("ü", "ö"),
                                  y = c("a", "s", "x"),
                                  x = c("s", "d", "c", "y"),
                                  c = c("d", "f", "v", "x"),
                                  v = c("f", "g", "b", "c"),
                                  b = c("g", "h", "n", "v"),
                                  n = c("h", "j", "m", "b"),
                                  m = c("j", "k", "n"))

# Save data in .rda-file and make it part of package
use_data(KeyboardNeighbors.German, overwrite = TRUE)



