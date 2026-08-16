
library(dplyr)
library(purrr)
library(stringr)
library(tidyr)


ICDOData <- readxl::read_xls("./Development/Data/Resources/ICD-O-3.2.xls")


FullCodes <- ICDOData %>%
                  filter(Level == "Preferred") %>%
                  select(Code, Term) %>%
                  mutate(ICDOMorphologyGroupCode = str_sub(Code, 1, 3),
                         ICDOMorphologyBehaviorCode = str_extract(Code, pattern = "/[^/]+$"),
                         ICDOMorphologyBehaviorLabel = case_match(ICDOMorphologyBehaviorCode,
                                                                  "/0" ~ "Benign",
                                                                  "/1" ~ "Uncertain whether benign or malignant",
                                                                  "/2" ~ "Carcinoma in situ",
                                                                  "/3" ~ "Malignant, primary site",
                                                                  "/6" ~ "Malignant, metastatic site",
                                                                  "/9" ~ "Malignant, uncertain whether primary or metastatic site"))

ExpandRange <- function(x)
{
  Bounds <- as.integer(str_split_1(x, "-"))
  if (length(Bounds) == 1) return(as.character(Bounds))
  return(str_c(seq(Bounds[1], Bounds[2]), collapse = ","))
}


MorphologyGroups <- ICDOData %>%
                        filter(Level == "2") %>%
                        select(Code, Term) %>%
                        mutate(Code = map_chr(Code, ExpandRange)) %>%
                        separate_longer_delim(cols = Code, delim = ",") %>%
                        rename(c(ICDOMorphologyGroupCode = "Code",
                                 ICDOMorphologyGroup = "Term"))

MorphologySubgroups <- ICDOData %>%
                            filter(Level == "3") %>%
                            select(Code, Term) %>%
                            mutate(Code = map_chr(Code, ExpandRange)) %>%
                            separate_longer_delim(cols = Code, delim = ",") %>%
                            rename(c(ICDOMorphologyGroupCode = "Code",
                                     ICDOMorphologyGroup.Sub1 = "Term"))

MorphologySubgroups2 <- ICDOData %>%
                            filter(Level == "4") %>%
                            select(Code, Term) %>%
                            mutate(Code = map_chr(Code, ExpandRange)) %>%
                            separate_longer_delim(cols = Code, delim = ",") %>%
                            rename(c(ICDOMorphologyGroupCode = "Code",
                                     ICDOMorphologyGroup.Sub2 = "Term"))


FullCodes <- FullCodes %>%
                  left_join(MorphologyGroups, by = join_by(ICDOMorphologyGroupCode)) %>%
                  left_join(MorphologySubgroups, by = join_by(ICDOMorphologyGroupCode)) %>%
                  left_join(MorphologySubgroups2, by = join_by(ICDOMorphologyGroupCode)) %>%
                  select(Code,
                         Term,
                         ICDOMorphologyGroupCode,
                         ICDOMorphologyGroup,
                         ICDOMorphologyGroup.Sub1,
                         ICDOMorphologyGroup.Sub2,
                         ICDOMorphologyBehaviorCode,
                         ICDOMorphologyBehaviorLabel) %>%
                  rename(c(ICDOMorphologyCode = "Code",
                           ICDOMorphologyLabel = "Term"))

write.csv2(FullCodes,
           file = "MorphologyGrouping.csv")

