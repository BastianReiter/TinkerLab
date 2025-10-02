
#' GetMatchingGrade
#'
#' Calculates the proportion of matching elements between two vectors
#'
#' @param VectorA \code{vector}
#' @param VectorB \code{vector}
#'
#' @return \code{double} - The proportion of matching elements
#' @export
#'
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GetMatchingGrade <- function(VectorA,
                             VectorB)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{

  return(sum(VectorA == VectorB, na.rm = TRUE) / length(VectorA))

}
