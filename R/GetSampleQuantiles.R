
#' GetSampleQuantiles
#'
#' Get key quantiles of a metric vector
#'
#' @param DataFrame Data Frame that contains metric feature
#' @param MetricFeature Metric feature
#' @param GroupingFeature Grouping feature
#' @param na.rm Logical; whether NA values should be removed before calculating quantiles
#'
#' @return A tibble containing quantiles
#' @export
#'
#' @examples
GetSampleQuantiles <- function(DataFrame,
                               MetricFeature,
                               GroupingFeature = NULL,
                               na.rm = FALSE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    # Create vector of quantile probabilities
    vc_Quantiles <- c(c(0.01, 0.025),
                      seq(from = 0.05, to = 0.95, by = 0.05),
                      c(0.975, 0.99))

    # Auxiliary vector for column names
    vc_QuantileNames <- purrr::map_chr(vc_Quantiles, ~paste0("P", .x * 100))

    # Using purrr::map, create a list of functions (in this case a set of quantile functions) to be mapped to the metric feature later on
    # Use purrr::partial to pre-define additional arguments for the set of quantile functions
    ls_f_Quantiles <- purrr::map(vc_Quantiles,
                                 ~ purrr::partial(quantile, probs = .x, na.rm = na.rm)) %>%
                                 purrr::set_names(vc_QuantileNames)

    # Apply mapping of quantile functions to the column defined by MetricFeature
    df_Output <- DataFrame %>%
                      summarize(across(.cols = {{ MetricFeature }},
                                       .fns = ls_f_Quantiles,
                                       .names = "{.fn}"))

    if (quo_is_null(enquo(GroupingFeature)) == FALSE)      # If GroupingFeature is not empty...
    {
      # Get group-specific output
      df_Groupwise <- DataFrame %>%
                          group_by(., {{ GroupingFeature }}) %>%
                          summarize(across(.cols = {{ MetricFeature }},
                                           .fns = ls_f_Quantiles,
                                           .names = "{.fn}"))

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
