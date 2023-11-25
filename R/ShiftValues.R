
#' ShiftValues
#'
#' @param Vector A vector object
#' @param Lag Size of lag as integer
#'
#' @return A Vector
#' @export
#'
#' @examples
ShiftValues <- function(Vector,
                        Lag)
{
    if (Lag %% length(Vector) == 0)
    {
        Output <- Vector
    }
    else
    {
        Output <- c(Vector[((Lag %% length(Vector)) + 1):length(Vector)], Vector[1:(Lag %% length(Vector))])
    }

    return(Output)
}
