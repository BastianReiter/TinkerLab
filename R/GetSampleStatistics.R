
#' GetSampleStatistics
#'
#' Get important sample statistics for a feature of a data frame
#'
#' @param DataFrame Data frame that contains the metric feature
#' @param MetricFeature Metric feature
#' @param GroupingFeature Grouping feature
#' @param na.rm Logical; whether NA values should be removed before calculating statistics
#'
#' @return A tibble containing the following statistics: sample size (N), minimum, maximum, Q1, Median, Q3, MAD, mean, standard deviation
#' @export
#'
#' @examples
GetSampleStatistics <- function(DataFrame,
                                MetricFeature,
                                GroupingFeature = NULL,
                                na.rm = FALSE)
{
    df_Output <- DataFrame %>%
                      summarize(N = n(),
                                Min = min({{ MetricFeature }}, na.rm = na.rm),
                                Max = max({{ MetricFeature }}, na.rm = na.rm),
                                q5 = quantile({{ MetricFeature }}, probs = 0.05, na.rm = na.rm),
                                Q1 = quantile({{ MetricFeature }}, probs = 0.25, na.rm = na.rm),
                                Median = median({{ MetricFeature }}, na.rm = na.rm),
                                Q3 = quantile({{ MetricFeature }}, probs = 0.75, na.rm = na.rm),
                                q95 = quantile({{ MetricFeature }}, probs = 0.95, na.rm = na.rm),
                                MAD = mad({{ MetricFeature }}, na.rm = na.rm),
                                Mean = mean({{ MetricFeature }}, na.rm = na.rm),
                                SD = sd({{ MetricFeature }}, na.rm = na.rm),
                                SEM = SD / sqrt(N))

    if (quo_is_null(enquo(GroupingFeature)) == FALSE)      # If GroupingFeature is not empty...
    {
        # Get group-specific output
        df_Groupwise <- DataFrame %>%
                            group_by(., {{ GroupingFeature }}) %>%
                            summarize(N = n(),
                                      Min = min({{ MetricFeature }}, na.rm = na.rm),
                                      Max = max({{ MetricFeature }}, na.rm = na.rm),
                                      q5 = quantile({{ MetricFeature }}, probs = 0.05, na.rm = na.rm),
                                      Q1 = quantile({{ MetricFeature }}, probs = 0.25, na.rm = na.rm),
                                      Median = median({{ MetricFeature }}, na.rm = na.rm),
                                      Q3 = quantile({{ MetricFeature }}, probs = 0.75, na.rm = na.rm),
                                      q95 = quantile({{ MetricFeature }}, probs = 0.95, na.rm = na.rm),
                                      MAD = mad({{ MetricFeature }}, na.rm = na.rm),
                                      Mean = mean({{ MetricFeature }}, na.rm = na.rm),
                                      SD = sd({{ MetricFeature }}, na.rm = na.rm),
                                      SEM = SD / sqrt(N))

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
