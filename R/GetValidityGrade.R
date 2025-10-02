
#' GetValidityGrade
#'
#' Calculates the proportion of valid elements in a given vector.
#'
#' @param Vector \code{vector} - Containing original values
#' @param ValidValues \code{vector} - A set of valid values
#' @param ValidRange.Min \code{double}
#' @param ValidRange.Max \code{double}
#'
#' @return \code{double} - The proportion of valid elements
#' @export
#'
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GetValidityGrade <- function(Vector,
                             ValidValues = NULL,
                             ValidRange.Min = NULL,
                             ValidRange.Max = NULL)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  #--- For testing purposes ---
  # TestData <- TinkerLab::ATCCoding %>%
  #                     filter(str_starts(Code, pattern = "L")) %>%
  #                     arrange(Substance) %>%
  #                     pull(Substance) %>%
  #                     MakeDirty() %>%
  #                     select(-Dirty) %>%
  #                     pivot_longer(cols = !Original,
  #                                  names_to = NULL,
  #                                  values_to = "Dirty")
  #
  # Vector <- TestData$Dirty
  # ValidValues <- unique(TestData$Original)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (!is.null(ValidValues))
  {
      return(sum(Vector %in% ValidValues, na.rm = TRUE) / length(Vector))
  }

  if (!is.numeric(Vector)) { return(NULL) }

  if (is.null(ValidRange.Min)) { ValidRange.Min <- min(Vector) }
  if (is.null(ValidRange.Max)) { ValidRange.Max <- max(Vector) }

  return(sum(Vector >= ValidRange.Min & Vector <= ValidRange.Max, na.rm = TRUE) / length(Vector))
}
