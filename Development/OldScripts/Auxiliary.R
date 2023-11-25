
################################################################################
#------------------------------------------------------------------------------#
#   CUSTOM AUXILIARY FUNCTIONS                                                 #
#------------------------------------------------------------------------------#
################################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PACKAGE DEPENDENCIES for this Script
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# library(colorspace)
# library(dplyr)
# library(ggpattern)
# library(ggplot2)
# library(showtext)
# library(sysfonts)



################################################################################
#--------- GENERAL AUXILIARY FUNCTIONS ----------------------------------------#
################################################################################


# Custom Infix Operator %notin%
'%notin%' <- function(x, y) { !(x %in% y) }


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Initialize Progress Bar Information Object
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   - Opens Progress Bar Widget
#   - Returns list
#-------------------------------------------------------------------------------
f_InitProgressBar <- function(inp_Title,
                              inp_ProgressTotalSteps)
{
    ls_ProgressInfo <- list(ProgressBar = tryCatch(tcltk::tkProgressBar(title = inp_Title), error = NULL),
                            ProgressBarTitle = inp_Title,
                            ProgressTotalSteps = inp_ProgressTotalSteps,
                            ProgressStepInfo = tibble(Step = 0,
                                                      Description = "Initiation",
                                                      TimeStamp = Sys.time(),
                                                      Duration = 0))

    try(tcltk::setTkProgressBar(pb = ls_ProgressInfo$ProgressBar,
                                value = 0,
                                title = inp_Title,
                                label = "0% done"),
        silent = TRUE)

    return(ls_ProgressInfo)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Update Progress
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  - Updates a Progress Bar Widget
#  - Returns tibble of Progress Step Info
#  - Prints out informations about finished task
#-------------------------------------------------------------------------------
f_UpdateProgressBar <- function(inp_ProgressInfo,
                                inp_StepDescription = NULL)
{
    df_StepInfo <- inp_ProgressInfo$ProgressStepInfo

    FinishedStep <- last(df_StepInfo$Step) + 1

    df_StepInfo <- df_StepInfo %>%
                        add_row(Step = FinishedStep,
                                Description = inp_StepDescription,
                                TimeStamp = Sys.time(),
                                Duration = round(as.numeric(difftime(TimeStamp, last(df_StepInfo$TimeStamp), units = "secs")), 0))

    NewProgressValue <- FinishedStep / inp_ProgressInfo$ProgressTotalSteps

    Info <- sprintf("%i%% done", round(NewProgressValue * 100, 0))

    try(tcltk::setTkProgressBar(pb = inp_ProgressInfo$ProgressBar,
                                value = NewProgressValue,
                                title = sprintf(paste(inp_ProgressInfo$ProgressBarTitle, "(%s)"), Info),
                                label = Info),
        silent = TRUE)

    # Print out information about finished task
    cat("Performed Step ",
            last(df_StepInfo$Step),
            ": '",
            ifelse(FinishedStep > 0,
                   last(df_StepInfo$Description),
                   "Initiation"),
            "' in ",
            as.character(duration(last(df_StepInfo$Duration), units = "seconds")),
            "\n",
        sep = "")

    return(df_StepInfo)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Initialize Attrition Tracker (auxiliary table to track sample sizes after filtering operations)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Returns a tibble
#-------------------------------------------------------------------------------
f_InitAttritionTracker <- function()
{
    df_AttritionTracker <- tibble(SampleSize = numeric(),
                                  InclusionComment = character(),
                                  ExclusionComment = character(),
                                  AttritionCount = numeric())
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Update Attrition Tracker
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Processes a tibble
#-------------------------------------------------------------------------------
f_UpdateAttritionTracker <- function(inp_df_AttritionTracker,
                                     inp_NewSampleSize,
                                     inp_InclusionComment = "",
                                     inp_ExclusionComment = "")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    inp_df_AttritionTracker %>%
        add_row(SampleSize = inp_NewSampleSize,
                InclusionComment = inp_InclusionComment,
                ExclusionComment = inp_ExclusionComment)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Close Attrition Tracker
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Processes a tibble
#-------------------------------------------------------------------------------
f_CloseAttritionTracker <- function(inp_df_AttritionTracker)
{
    inp_df_AttritionTracker %>%
        mutate(AttritionCount = SampleSize - lead(SampleSize)) %>%
        rowid_to_column() %>%
        rename(Step = rowid)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get Table with Information about Data Object Structure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Returns a tibble
#-------------------------------------------------------------------------------
f_GetObjectInfo <- function(inp_ObjectNames,
                            inp_Environment)
{
    df_ObjectInfo <- tibble(Object_Name = character(),
                            Object_R_Type = character(),
                            Object_Category = character(),
                            Object_Attributes = character(),
                            Number_of_Rows = numeric())

    for (i in 1:length(inp_ObjectNames))
    {
        CurrentObject_Name <- inp_ObjectNames[i]
        CurrentObject <- get(CurrentObject_Name, envir = inp_Environment)

        CurrentObject_RType <- type_of(CurrentObject)

        CurrentObject_Category <- "Other"
        if (str_starts(CurrentObject_Name, "df")) { CurrentObject_Category <- "Table" }
        if (str_starts(CurrentObject_Name, "plot")) { CurrentObject_Category <- "Plot Object" }
        if (str_starts(CurrentObject_Name, "model")) { CurrentObject_Category <- "Model Object" }
        if (str_starts(CurrentObject_Name, "ls")) { CurrentObject_Category <- "eCDF Object" }
        if (str_starts(CurrentObject_Name, "Validation")) { CurrentObject_Category <- "Meta Data" }

        CurrentObject_Attributes <- paste(colnames(CurrentObject), collapse = ", ")

        CurrentObject_NumberOfRows <- NA
        if (CurrentObject_Category == "Table") { CurrentObject_NumberOfRows <- nrow(CurrentObject) }

        df_ObjectInfo <- df_ObjectInfo %>%
                              add_row(Object_Name = CurrentObject_Name,
                                      Object_R_Type = CurrentObject_RType,
                                      Object_Category = CurrentObject_Category,
                                      Object_Attributes = CurrentObject_Attributes,
                                      Number_of_Rows = CurrentObject_NumberOfRows)
    }

    return(df_ObjectInfo)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get Table with Information about Data Frame Attributes
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Returns a tibble
#-------------------------------------------------------------------------------
f_GetAttributesInfo <- function(inp_DataFrameName,
                                inp_Environment,
                                inp_IncludeRandomExampleValues = FALSE,         # Boolean whether to include random values in the form of independent values (so not coming from the same row)
                                inp_IncludeRandomRow = FALSE)                   # Boolean whether to include random values in the form of dependent values (from a randow row)
{
    df_InputDataFrame <- get(inp_DataFrameName, envir = inp_Environment)

    df_AttributesInfo <- tibble(Object = inp_DataFrameName,
                                AttributeName = colnames(df_InputDataFrame),
                                AttributeDataType = sapply(df_InputDataFrame, class))      # Get Data Type of each Attribute

    # Include independent random values
    if (inp_IncludeRandomExampleValues == TRUE)
    {
      vc_RandomValues <- unlist(map(1:ncol(df_InputDataFrame),
                                    function(x) { toString(pull(df_InputDataFrame[sample(1:nrow(df_InputDataFrame), 1), x])) }))      # The combination of toString() and pull() is necessary to preserve date format

      df_AttributesInfo <- df_AttributesInfo %>% add_column(ExampleValue = vc_RandomValues)
    }

    # Include random row (dependent values)
    if (inp_IncludeRandomExampleValues == FALSE && inp_IncludeRandomRow == TRUE)
    {
      vc_RandomRow <- unlist(map(df_InputDataFrame[sample(1:nrow(df_InputDataFrame), 1), ],
                                 toString))      # Extract random row (as a list to preserve data types) and convert every value to character using toString() (preserves date format) and unlist to get character vector

      df_AttributesInfo <- df_AttributesInfo %>% add_column(ExampleValue = vc_RandomRow)
    }

    return(df_AttributesInfo)
}



################################################################################
#--------- DATA SCREENING METHODS ---------------------------------------------#
################################################################################


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Track occurrence of a feature's unique values, their eligibility and frequency
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Returns a tibble
#-------------------------------------------------------------------------------
f_TrackFeatureValues <- function(inp_df,
                                 inp_Features,      # List of vectors. Name of vector object gives name of feature, optional vector values give eligible values.
                                 inp_ProcessingStatus = NULL)
  {
    df_Output <- tibble(Feature = character(),
                        Value = character(),
                        IsValueEligible = logical(),
                        ProcessingStatus = character(),
                        Frequency = numeric())

    for (feature in names(inp_Features))
    {
        vc_ContingencyTable <- table(inp_df[[feature]], useNA = "always")      # table() returns a contingency table in the form of a named vector. Vector element names are the occurring values, vector element values are the corresponding absolute frequencies.

        vc_EligibleValues <- inp_Features[[feature]]      # Get eligible values from optional vector values

        df_FeatureRows <- tibble(Feature = feature,
                                 Value = names(vc_ContingencyTable),      # Get all distinct values from contingency table
                                 IsValueEligible = NA,
                                 ProcessingStatus = inp_ProcessingStatus,
                                 Frequency = as.numeric(vc_ContingencyTable)) %>%      # Get absolute frequencies from contingency table
                              arrange(Value)

        if (!is.null(vc_EligibleValues))      # If vector of eligible values is passed (so not null),
        {
            df_FeatureRows <- df_FeatureRows %>%
                                  mutate(IsValueEligible = Value %in% vc_EligibleValues) %>%      # ... see which values are in it
                                  arrange(IsValueEligible, Value)
        }

        df_Output <- bind_rows(df_Output, df_FeatureRows)
    }

    return(df_Output)
}



################################################################################
#--------- WRANGLING OPERATIONS -----------------------------------------------#
################################################################################


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Custom Value Recoding
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Returns a vector
#-------------------------------------------------------------------------------
f_Recode <- function(inp_TargetVector,
                     inp_Dictionary)      # A Named Character Vector. Vector Names are Lookup Values, Vector Values are Substitute Values.
{
    # Lookup Values come from names(inp_Dictionary)
    vc_LookupValues <- regex(paste0("^",      # Embrace Lookup Values with "^" and "$" to isolate them, so that for example "R" is not recognized (and replaced) in "CR", but only when it stands isolated
                                    str_escape(names(inp_Dictionary)),      # Introduce escaping of special characters, for example "(" and "/"
                                    "$"))

    # Add "Protection Prefix" to mark freshly changed Values, so that they won't be looked up themselves
    vc_NewValues <- paste0("NEW_", inp_Dictionary)
    names(vc_NewValues) <- vc_LookupValues

    vc_Output <- stringr::str_replace_all(inp_TargetVector, vc_NewValues)
    vc_Output <- stringr::str_remove_all(vc_Output, "NEW_")      # Remove the introduced "Protection Prefix"

    return(vc_Output)
}





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Make Line Plot
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
f_MakeLinePlot <- function(inp_df,
                           inp_X,
                           inp_Y,
                           inp_GroupingFeature,
                           inp_ggTheme = function(...) theme_CCP(...),
                           inp_LegendPosition = "right",                        # Optional: "top", "bottom", "left", "none"
                           inp_ls_ThemeArguments = list(),                      # Pass custom theme arguments
                           ...)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    #--- Process plot data -----------------------------------------------------

    df_Plotdata <- inp_df %>%
                      ungroup() %>%
                      select({{ inp_X }},
                             {{ inp_Y }},
                             {{ inp_GroupingFeature }}) %>%
                      rename(X = {{ inp_X }},      # Rename columns for easier processing
                             Y = {{ inp_Y }},
                             GroupingFeature = {{ inp_GroupingFeature }})


    plot <- ggplot(data = df_Plotdata,
                   aes(x = X,
                       y = Y,
                       group = GroupingFeature)) +
            do.call(inp_ggTheme, c(list(...),      # Apply custom theme with optional arguments as concatenated lists
                                   list(inp_Theme_LegendPosition = inp_LegendPosition),      # Because legend position is often used, it gets its own argument
                                   inp_ls_ThemeArguments)) +
            geom_line()



            #
            # labs(x = inp_AxisTitle_x,
            #      y = inp_AxisTitle_y) +
            # #--- Option: If no axis title, delete space for label --------------
            # {
            #   if (inp_AxisTitle_x == "") { theme(axis.title.x = element_blank()) }
            # } + {
            #   if (inp_AxisTitle_y == "") { theme(axis.title.y = element_blank()) }
            # }


}






