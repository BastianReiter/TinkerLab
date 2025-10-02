

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Fuzzy String Matching (using package 'stringdist')
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(dplyr)
library(stringdist)
library(stringr)
library(tidyr)


# Get test data and create string modifications for testing purposes
Substances <- TinkerLab::ATCCoding %>%
                  filter(str_starts(Code, pattern = "L")) %>%
                  pull(Substance)

TestData <- tibble(Original = Substances) %>%
                mutate(Dirty = MakeDirty(Original, AffectedProportion = 0.7)) %>%
                arrange(Original)

GetValidityGrade(TestData$Dirty, unique(TestData$Original))


Test <- TestData %>%
            mutate(Match = GetFuzzyStringMatches(Vector = Dirty,
                                                 ValidStrings = unique(Original),
                                                 Method = "osa",
                                                 Tolerance = 0.7))

GetMatchingGrade(Test$Original, Test$Match)

