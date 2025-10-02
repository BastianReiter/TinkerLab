
#' InsertTypo
#'
#' Insert a random typo into a string
#'
#' @param String \code{string}
#' @param Type \code{string} - Refers to the type of typo, one of the following:
#'        \itemize{ \item 'double' - Clone a random letter and insert it
#'                  \item 'add' - Add a keyboard-neighboring letter to a random letter
#'                  \item 'replace' - Replace a random letter with a keyboard-neighboring letter
#'                  \item 'random' - Choose randomly one of the above (Default) }
#'
#' @return \code{string} with inserted typo
#' @export
#'
#' @author Bastian Reiter
InsertTypo <- function(String,
                       Type = "random")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    #--- For testing purposes ---
    # String <- "Abrakadabra"
    # Type <- "add"

    try(
    {

        letter <- NA
        looplimiter <- 0
        letterCase <- "lower"

        while(!(letter %in% c(base::letters, "ä", "ö", "ü")) & looplimiter < 20)      # This ensures that 'letter' is a valid letter and that the while-loop is not infinite
        {
            # Get a random position in the string...
            randomPosition <- sample(1:nchar(String), size = 1)
            # ... and the corresponding letter/character
            letter <- substr(String, start = randomPosition, stop = randomPosition)

            if (letter %in% c(base::LETTERS, "Ä", "Ö", "Ü"))
            {
                letterCase <- "upper"
                letter <- tolower(letter)
            }

            looplimiter <- looplimiter + 1      # This ensures that while-loop is not infinite
        }

        # Get a random neighboring letter based on the layout of a german keyboard (using data from package 'TinkerLab')
        Neighbors <- KeyboardNeighbors.German[[letter]]
        randomNeighbor <- sample(Neighbors, size = 1)

        # If originally the randomly chosen letter was of upper case, restore this
        if (letterCase == "upper") { letter <- toupper(letter) }

        # If 'Type' is set on 'random' get a random type of typo before proceeding
        if (Type == "random") { Type <- sample(c("add", "double", "replace"), size = 1) }

        if (Type == "double")
        {
            String <- paste0(substr(String, start = 1, stop = (randomPosition - 1)),
                             letter, letter,
                             substr(String, start = (randomPosition + 1), stop = nchar(String)))
        }

        if (Type == "replace")
        {
            if (letterCase == "upper") { randomNeighbor <- toupper(randomNeighbor) }
            substr(String, start = randomPosition, stop = randomPosition) <- randomNeighbor
        }

        if (Type == "add")
        {
            String <- paste0(substr(String, start = 1, stop = (randomPosition - 1)),
                             paste(c(letter, randomNeighbor)[sample(c(1, 2), size = 2)], collapse = ""),
                             substr(String, start = (randomPosition + 1), stop = nchar(String)))
        }

    }, silent = TRUE)

    return(String)
}
