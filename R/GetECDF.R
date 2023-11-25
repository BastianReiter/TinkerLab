
#' GetECDF
#'
#' Get Empirical Cumulative Distribution Function (ECDF)
#'
#' @param DataFrame Data frame that contains the metric feature
#' @param MetricFeature Metric feature
#' @param GroupingFeature Grouping feature
#' @param na.rm Logical; whether NA values should be removed before estimating the CDF
#'
#' @return An ECDF object
#' @export
#'
#' @examples
GetECDF <- function(DataFrame,
                    MetricFeature,
                    GroupingFeature = NULL,
                    na.rm = FALSE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    df_Input <- DataFrame

    # Remove missing values if desired
    if (na.rm == TRUE)
    {
        df_Input <- df_Input %>%
                        filter(., is.na({{ MetricFeature }}) == FALSE)
    }

    # Cumulated output
    df_Output <- df_Input %>%
                      summarize(eCDF = list(ecdf({{ MetricFeature }})))

    # Groupwise output
    if (quo_is_null(enquo(GroupingFeature)) == FALSE)      # If GroupingFeature is not empty...
    {
        df_Groupwise <- df_Input %>%
                            group_by(., {{ GroupingFeature }}) %>%
                                summarize(eCDF = list(ecdf({{ MetricFeature }})))

        # Create Extra column for later rbinding
        df_Output <- df_Output %>%
                          mutate(dummy = "All", .before = 1)

        # Harmonize column names for rbinding
        colnames(df_Output) <- colnames(df_Groupwise)

        df_Output <- rbind(df_Output,
                           df_Groupwise)
    }

    return(df_Output)
}
