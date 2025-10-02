
#' MakeDirty
#'
#' Introduce a variety of noise into clean text data, including:
#' \itemize{\item Typos
#'          \item Truncation
#'          \item Addition
#'          \item First case flip
#'          \item Total case flip}
#'
#' @param Vector \code{character vector} - 'Clean' string data
#' @param AffectedProportion \code{double} - Proportion of vector affected by noise - Default: 0.3
#' @param ReturnModificationTibble \code{logical} - Optionally return a \code{tibble} containing various modifications for the random selection of affected original values - Default: \code{FALSE}
#'
#' @return Either
#'            \itemize{\item A \code{vector} of 'dirty' strings (default), or
#'                     \item If argument 'ReturnModificationTibble' is set \code{TRUE}, a \code{tibble} containing various modifications performed on the random selection of original values }
#' @export
#'
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MakeDirty <- function(Vector,
                      AffectedProportion = 0.3,
                      ReturnModificationTibble = FALSE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
require(dplyr)
require(stringr)

#--- For testing purposes ---
# Vector <- TinkerLab::ATCCoding %>%
#               filter(str_starts(Code, pattern = "L")) %>%
#               pull(Substance)
# AffectedProportion <- 0.5
# ReturnModificationTibble <- FALSE

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Randomly choose sample IDs based on 'AffectedProportion' to determine which vector elements should be modified
ChosenElements <- sample.int(n = length(Vector),
                             size = round(AffectedProportion * length(Vector)),
                             replace = FALSE)

# Create tibble with ID column, original values and selector column
Root <- tibble(ID = 1:length(Vector),
               Original = Vector,
               Modified = ID %in% ChosenElements)

# Create columns with various modifications for selected subset
Modifications <- Root %>%
                      filter(Modified == TRUE) %>%
                      select(-Modified) %>%
                      rowwise() %>%
                      mutate(Typo = InsertTypo(Original, Type = "random"),
                             Truncated = {  minpos <- round(nchar(Original) * 0.6)      # Do not truncate before minimal position defined by 60% of the string
                                            remaining <- nchar(Original) - minpos      # Get remaining number of letters
                                            substr(Original, start = 1, stop = (minpos + sample(0:remaining, 1))) },      # Randomly truncate somewhere from 60% of the string
                             #Addition =
                             FirstCaseFlip = {  first <- substr(Original, 1, 1)
                                                if (first %in% c(base::LETTERS, "Ä", "Ö", "Ü")) { Result <- paste0(tolower(first), substr(Original, 2, nchar(Original)), collapse = "") }
                                                else { Result <- paste0(toupper(first), substr(Original, 2, nchar(Original)), collapse = "") }
                                                Result },
                             TotalCaseFlip = chartr(old = paste0(base::letters, base::LETTERS, collapse = ""),
                                                    new = paste0(base::LETTERS, base::letters, collapse = ""),
                                                    x = Original)) %>%
                      ungroup()

# Get names of modification columns
ModCategories <- names(Modifications)[!(names(Modifications) %in% c("ID", "Original"))]


ModificationTibble <- Root %>%
                          left_join(Modifications, by = join_by(ID, Original)) %>%
                          mutate(Selection = case_when(Modified == TRUE ~ ModCategories[sample.int(n = length(ModCategories),
                                                                                        size = length(Original),
                                                                                        replace = TRUE)],
                                                       .default = "Original")) %>%
                          rowwise() %>%
                          mutate(Output = pick(everything())[[Selection]]) %>%
                          select(-ID)


if (ReturnModificationTibble == TRUE) { return(ModificationTibble) }

return(ModificationTibble$Output)
}
