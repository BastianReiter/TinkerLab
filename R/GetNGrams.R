
#' GetNGrams
#'
#' Get n-gram tokens from a character string
#'
#' @param String \code{string}
#' @param n \code{integer} - Length of tokens - Default: 1

#' @return \code{vector} of n-grams
#' @export
GetNGrams <- function(String,
                      n = 1)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(stringr)

    String <- str_to_lower(str_remove_all(String, pattern = " "))      # Delete all white space and make lower case

    if (nchar(String) <= n) { return(String) }

    NGrams <- sapply(X = 1:(nchar(String) - n + 1),
                     function(i) str_sub(String,
                                         start = i,
                                         end = i + n -1))

    return(NGrams)
}
