
#' MakePlot_BoxViolin
#'
#' @param DataFrame The data frame containing plot data
#' @param XFeature Contains X Values
#' @param XFeatureSelection Optional: Character vector that determines selection and order of categories
#' @param YFeature Contains Y Values
#' @param OutlierQuantile If set on "1", no outliers are cut
#' @param OutlierAcrossAll If TRUE, outliers will be calculated across all subgroups
#' @param LogTransform Optional: Whether Y data should be transformed using natural logarithm
#' @param ShowViolinPlot Optional: Control visibility of violin plot
#' @param AxisLimits_y Auto y axis limits as default
#' @param AxisTitle_x
#' @param AxisTitle_y
#' @param TickLabelWidth_x
#' @param Decimals Number of decimals of y axis number format
#' @param ggTheme Pass custom theme
#' @param ThemeArguments Pass custom theme arguments
#' @param FillPalette
#' @param ...
#'
#' @return a ggplot2 object
#' @export
#'
#' @examples
MakePlot_BoxViolin <- function(DataFrame,
                               XFeature,
                               XFeatureSelection = NULL,
                               YFeature,
                               OutlierQuantile = 1,
                               OutlierAcrossAll = TRUE,
                               LogTransform = FALSE,
                               ShowViolinPlot = TRUE,
                               AxisLimits_y = c(NA_integer_, NA_integer_),
                               AxisTitle_x = "",
                               AxisTitle_y = "",
                               TickLabelWidth_x = 10,
                               Decimals = 0,
                               ggTheme = function(...) TinkerLab::ggTheme_Tinker(...),
                               ThemeArguments = list(),
                               FillPalette = NULL,
                               ...)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    #--- Process plot data -----------------------------------------------------

    df_Plotdata <- DataFrame %>%
                        ungroup() %>%
                        select({{ XFeature }},
                               {{ YFeature }}) %>%
                        rename(X = {{ XFeature }},      # Rename columns for easier further processing
                               Y = {{ YFeature }}) %>%
                        { #--- Option: Determine X value selection and order
                          if (is.null(XFeatureSelection) == FALSE)
                          { mutate(., X = factor(X, levels = XFeatureSelection)) %>%
                            filter(., is.na(X) == FALSE) }
                          else {.}
                        } %>%
                        group_by(X) %>%
                        { #--- Option: Calculate outlier thresholds across all subgroups
                          if (OutlierAcrossAll == TRUE)
                          { ungroup(.) }   # By ungrouping here, the following outlier filtering is applied across all measured individuals and not within subgroups
                          else {.}
                        } %>%
                        #--- Filtering out outliers for "clearer" data visualization
                        filter(Y <= quantile(Y, probs = OutlierQuantile, na.rm = TRUE)) %>%
                        { #--- Option: Logarithmic transformation for "clearer" data visualization
                          if (LogTransform == TRUE)
                          { mutate(., Y = log(Y)) }   # Transforming data with natural logarithm to get "clearer" data visualization
                          else {.}
                        } %>%
                        group_by(X)


    #--- Plot ------------------------------------------------------------------

    plot <- ggplot(data = df_Plotdata,
                   aes(x = X,
                       y = Y,
                       fill = X)) +
            do.call(ggTheme, c(list(...),
                                   list(Theme_SizeFactorTickLabels_x = 1.3),      # Increase x axis tick label text size by default
                                   ThemeArguments)) +      # Pass additional optional arguments
            {
              if (ShowViolinPlot == TRUE)
              {
                  geom_violin(width = 0.8,
                              alpha = 0.4,
                              show.legend = FALSE)
              }
            } +
            geom_boxplot(width = 0.4,
                         alpha = 0.7,
                         outlier.shape = NA,
                         show.legend = FALSE) +
            labs(x = AxisTitle_x,
                 y = AxisTitle_y) +
            #--- Option: If no axis title, delete space for label --------------
            {
              if (AxisTitle_x == "") { theme(axis.title.x = element_blank()) }
            } + {
              if (AxisTitle_y == "") { theme(axis.title.y = element_blank()) }
            } +
            scale_x_discrete(labels = label_wrap(TickLabelWidth_x)) +      # Set width of x axis tick mark labels, after which linebreak should occur
            scale_y_continuous(labels = function(value) round(value, Decimals)) +
            ylim(AxisLimits_y[1], AxisLimits_y[2]) +      # Set y axis limits
            scale_fill_manual(values = FillPalette)      # Set custom fill color palette
}
