
#' GetFuzzyStringMatches
#'
#' Use fuzzy string matching (using package \code{stringdist}) to match elements of a character vector to a set of valid strings and return the transformed vector.
#'
#' @param Vector \code{character vector} - Containing original values
#' @param ValidStrings \code{character vector} - A set of valid/eligible strings
#' @param Method \code{string} - Determining the method \code{stringdist()} uses (see \code{stringdist} documentation) - Default: 'osa'
#' @param FindBestMethod \code{logical} - Indicating whether this function should try out all available methods and choose the one that yields the best result in terms of highest proportion of correctly matched vector elements. - Default: \code{FALSE}
#' @param Tolerance \code{double} - Number between 0 and 1 relating to normalized distance between to strings (1 meaning furthest distance, 0 meaning no distance). If a string in 'Vector' is not similar enough to any of the 'ValidStrings' and its minimal harmonized distance exceeds this number, it is set \code{NA}. Default: 0.5
#' @param Preprocessing.FlattenCase \code{logical} - If set to \code{TRUE} all letters in both the input and valid strings are transformed to lower case
#' @param Preprocessing.RemoveAllWhiteSpace \code{logical} - If set to \code{TRUE} all white space in both the input and valid strings is being removed
#' @param Preprocessing.SquishWhiteSpace \code{logical} - If set to \code{TRUE} all leading and trailing white space in both the input and valid strings is being removed and internal white space removed to a single space
#' @param ... Additional arguments used in \code{stringdist::stringdist()}
#'
#' @return \code{character vector} of transformed strings
#' @export
#'
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GetFuzzyStringMatches <- function(Vector,
                                  ValidStrings,
                                  Method = "osa",
                                  FindBestMethod = FALSE,
                                  Tolerance = 0.5,
                                  Preprocessing.FlattenCase = TRUE,
                                  Preprocessing.RemoveAllWhiteSpace = FALSE,
                                  Preprocessing.SquishWhiteSpace = TRUE,
                                  ...)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  require(dplyr)
  require(purrr)
  require(stringdist)
  require(stringr)

  # --- For testing purposes ---
  # Substances <- TinkerLab::ATCCoding %>%
  #                   filter(str_starts(Code, pattern = "L")) %>%
  #                   pull(Substance)
  #
  # TestData <- tibble(Original = Substances) %>%
  #                 mutate(Dirty = TinkerLab::MakeDirty(Original, AffectedProportion = 1)) %>%
  #                 arrange(Original)
  #
  # Vector <- TestData$Dirty
  # ValidStrings <- TestData$Original %>% unique()
  # Method <- "osa"
  # FindBestMethod <- TRUE
  # Tolerance <- 0.5
  # Preprocessing.FlattenCase <- TRUE
  # Preprocessing.RemoveAllWhiteSpace <- FALSE
  # Preprocessing.SquishWhiteSpace <- TRUE

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Initialize 'ValidStringsMod' as a container for possible modifications of 'ValidStrings'. The original 'ValidStrings' are still needed later for the return value.
  ValidStringsMod <- ValidStrings

  # For every preprocessing steps both input AND set of valid strings are being modified to enhance chance for matching
  if (Preprocessing.FlattenCase == TRUE)
  {
      Vector <- tolower(Vector)
      ValidStringsMod <- tolower(ValidStringsMod)
  }
  if (Preprocessing.SquishWhiteSpace == TRUE)
  {
      Vector <- str_squish(Vector)      # 'str_squish' removes all leading and trailing white space and reduces all internal white space to a single one
      ValidStringsMod <- str_squish(ValidStringsMod)
  }
  if (Preprocessing.RemoveAllWhiteSpace == TRUE)
  {
      Vector <- str_replace_all(Vector, " ", "")      # Remove ALL white space
      ValidStringsMod <- str_replace_all(ValidStringsMod, " ", "")
  }

  # Auxiliary function to get best fuzzy string match in 'ValidStrings' for a particular string
  GetBestMatch <- function(String,
                           Method)
                  {
                      # Compute string distances from current string to all valid strings
                      Distances <- stringdist(a = String,
                                              b = ValidStringsMod,
                                              method = Method)

                      # The current string's lowest distance to any of the valid strings
                      lowestdistance <- min(Distances)

                      # Identify the valid string with smallest distance to current string
                      bestmatch <- ValidStringsMod[which.min(Distances)]

                      # Depending on the used method 'lowestdistance' can either already be a number between 0 (no distance) and 1 (maximal distance) or it needs to be normalized accordingly to make the 'Tolerance' argument meaningful
                      lowestdistance.norm <- lowestdistance      # Methods 'jaccard', 'jw', 'cosine', 'soundex' return distance measures between 0 and 1

                      if (Method %in% c("osa", "lv", "dl"))      # Length-based edit distances
                      {
                          lowestdistance.norm <- lowestdistance / max(nchar(string), nchar(bestmatch))
                      }
                      if (Method %in% c("lcs", "qgram"))
                      {
                          lowestdistance.norm <- lowestdistance / (nchar(string) + nchar(bestmatch))
                      }
                      # Method 'hamming' returns Inf for two strings with different numbers of characters and is therefore not supported (because we can not find a maximum that would allow normalization)

                      # Get the original value of best match (before valid strings were modified)
                      bestmatch.original <- ValidStrings[which(ValidStringsMod == bestmatch)]

                      # If the normalized distance is lower or equal than the 'Tolerance' value, the best match is returned, otherwise return the current string as it was
                      if (lowestdistance.norm <= Tolerance) { return(bestmatch.original) }
                      else { return(NA) }
                  }

  # If option 'FindBestMethod' is set to TRUE, try out all available methods and choose the one with the highest posterior validity grade
  if (FindBestMethod == TRUE)
  {
      Methods <- c("osa", "lv", "dl", "lcs", "qgram", "cosine", "jaccard", "jw", "soundex")

      # Apply all methods and return results as well as method-specific performance (validity grade)
      MethodApplication <- Methods %>%
                              map(function(method)
                              {
                                  # Get best matches for every element in 'Vector' with the current method
                                  BestMatches <- sapply(Vector,
                                                        GetBestMatch,
                                                        Method = method)

                                  # To measure method performance calculate proportion of valid elements in 'BestMatches' after matching
                                  ValidityGrade <- sum(BestMatches %in% ValidStrings, na.rm = TRUE) / length(BestMatches)

                                  return(list(BestMatches = BestMatches,
                                              ValidityGrade = ValidityGrade))
                              }) %>%
                              set_names(Methods) %>%
                              list_transpose()   # Transpose list to ease further processing

      # Determine best method based on highest posterior validity grade
      BestMethod <- Methods[which.max(MethodApplication$ValidityGrade)]

      # Return best matches of best method
      return(MethodApplication$BestMatches[[BestMethod]])

  } else {

      # Get best matches for every element in 'Vector' with the method determined in 'Method' and return them
      BestMatches <- sapply(Vector,
                            GetBestMatch,
                            Method)
      return(BestMatches)
  }
}
