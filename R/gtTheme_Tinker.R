
#' gtTheme_Tinker
#'
#' Custom gt theme
#'
#' Can be applied to gt table objects from gt package
#'
#' @param gtObject A gt table object
#' @param ShowNAs logical; whether NA values should be printed
#' @param TableWidth
#' @param TableAlign
#' @param ...
#'
#' @return A (modified) gt table object
#' @export
#'
#' @examples
#'
gtTheme_Tinker <- function(gtObject,
                           ShowNAs = FALSE,
                           TableWidth = NULL,
                           TableAlign = "center",
                           BaseFontSize = "80%",
                           ...)
{
    require(gt)

    # Add google font "Karla"
    sysfonts::font_add_google(name = "Karla", family = "Karla")

    gtObject %>%
        tab_options(table.width = TableWidth,
                    table.align = TableAlign,
                    table.font.names = c("Karla", default_fonts()),
                    table.font.size = BaseFontSize,
                    heading.align = "center",
                    table.border.top.width = NULL,
                    column_labels.background.color = TinkerLab::Colors$PrimaryLight,
                    column_labels.border.top.width = NULL,
                    column_labels.border.bottom.width = 3,
                    column_labels.border.bottom.color = TinkerLab::Colors$Primary,
                    row_group.background.color = TinkerLab::Colors$LightGrey) %>%
        #--- Style column label text ---
        tab_style(locations = cells_column_labels(),
                  style = paste0("vertical-align: middle;
                                  text-transform: uppercase;
                                  font-weight: bold;
                                  color: ", TinkerLab::Colors$Primary)) %>%
        #--- Format column label text (Replace "_" with " ")
        text_replace(locations = cells_column_labels(),
                     pattern = "[_]",
                     replacement = " ") %>%
        #--- Style row group label ---
        tab_style(locations = cells_row_groups(),
                  style = paste0("font-weight: bold; color: ", TinkerLab::Colors$Primary)) %>%
        { if (ShowNAs == FALSE)
        { sub_missing(., missing_text = "") }
          else {.}
        }
}
