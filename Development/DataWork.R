
#==============================================================================#
#------------------------------------------------------------------------------#
#   TinkerLab: Data processing                                                 #
#------------------------------------------------------------------------------#
#==============================================================================#


library(readxl)
library(usethis)


#===============================================================================
# Meta Data: ATC Codes
#===============================================================================

use_data(ATCData, overwrite = TRUE)



#===============================================================================
# Meta Data: Cancer Coding
#===============================================================================

FilePath <- "Development/Data/TinkerLab_CancerCoding.xlsx"

# Data on Cancer Grouping
#~~~~~~~~~~~~~~~~~~~~~~~~
CancerGrouping <- read_excel(path = FilePath,
                             sheet = "CancerGrouping")

# Save data in .rda-file and make it part of package
use_data(CancerGrouping, overwrite = TRUE)


# Data on Cancer Surgery
#~~~~~~~~~~~~~~~~~~~~~~~
CancerSurgery <- read_excel(path = FilePath,
                            sheet = "CancerSurgery")

# Save data in .rda-file and make it part of package
use_data(CancerSurgery, overwrite = TRUE)



#===============================================================================
# Meta Data: OPS coding
#===============================================================================

FilePath <- "Development/Data/TinkerLab_OPSCoding.xlsx"

# Data on OPS Coding
#~~~~~~~~~~~~~~~~~~~
OPSCodes <- read_excel(path = FilePath,
                       sheet = "OPSCodes")

# Save data in .rda-file and make it part of package
use_data(OPSCodes, overwrite = TRUE)



#===============================================================================
# Meta Data: Working with P21 data
#===============================================================================

FilePath <- "Development/Data/TinkerLab_P21.xlsx"

df_Meta_DischargeReasons <- read_excel(path = FilePath,
                                       sheet = "DischargeReasons")

df_Meta_Departments <- read_excel(path = here("Data/MetaData/MetaData_Project.xlsx"),
                                  sheet = "Departments")
