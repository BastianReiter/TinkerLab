
#' XMLToDataModel
#'
#' Make List of data frames describing a data model
#'
#' @param XMLSchemaFilePath
#' @param TableNodeElement
#' @param TableNameAttribute
#' @param ColumnNodeElement
#' @param ColumnNameAttribute
#'
#' @return A list of data frames
#' @export
#'
#' @examples
XMLToDataModel <- function(XMLSchemaFilePath,
                           TableNodeElement = "container",
                           TableNameAttribute = "opal-table",
                           ColumnNodeElement = "attribute",
                           ColumnNameAttribute = "csv-column")
{
    # Read xml file
    XMLSchema = xml2::read_xml(XMLSchemaFilePath)

    # Find "Table" nodes in Schema
    xml_TableNodes <- xml2::xml_find_all(x = XMLSchema,
                                         xpath = paste0(".//", TableNodeElement))

    # Get names of tables
    vc_TableNames <- xml2::xml_attr(x = xml_TableNodes,
                                    attr = TableNameAttribute)

    # Get a list of data frames being named after the containers in the XML Schema
    ls_DataModel <- purrr::map(.x = vc_TableNames,
                               .f = function(x)
                                    {
                                        xml_ColumnNodes <- xml2::xml_find_all(x = XMLSchema,
                                                                              xpath = paste0(".//", TableNodeElement, "[@", TableNameAttribute, "='", x, "']/", ColumnNodeElement))

                                        vc_ColumnNames <- xml2::xml_attr(x = xml_ColumnNodes,
                                                                         attr = ColumnNameAttribute)

                                        DataFrame <- data.frame()

                                        # Optional for future purposes: Extract column data types
                                        #--------------------------------------------------------
                                        # vc_ColumnTypes <- xml2::xml_attr(x = xml_ColumnNodes,
                                        #                                  attr = ColumnTypeAttribute)

                                        # for (i in 1:length(vc_ColumnNames))
                                        # {
                                        #     Column <- as.character(NULL)
                                        #     if (vc_ColumnTypes[i] == "integer") { Column <- as.integer(NULL) }
                                        #     if (vc_ColumnTypes[i] == "double") { Column <- as.double(NULL) }
                                        #     if (vc_ColumnTypes[i] == "boolean") { Column <- as.logical(NULL) }
                                        #     if (vc_ColumnTypes[i] == "date") { Column <- as.Date(NULL) }
                                        #
                                        #     DataFrame <- cbind(DataFrame, Column)
                                        # }

                                        for (i in 1:length(vc_ColumnNames))
                                        {
                                            Column <- as.character(NULL)
                                            DataFrame <- cbind(DataFrame, Column)
                                        }

                                        colnames(DataFrame) <- vc_ColumnNames

                                        return(DataFrame)

                                     }) %>%
                          purrr::set_names(nm = vc_TableNames)      # Set list element names

    # Return the data model as data frames in a list
    return(ls_DataModel)
}
