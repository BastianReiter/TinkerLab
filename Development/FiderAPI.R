
#===============================================================================
#
# Fider API
#
#===============================================================================

# Fider API documentation: https://docs.fider.io/api/overview

#-------------------------------------------------------------------------------


library(dplyr)
library(httr2)
library(purrr)

BaseURL <- "https://scienceteams.fider.io"
Token <- "xQWcWvNYFxLcUNuAmbY9dtDMcPott00esJ2SNHvIzkj83HrdbXIE3zEOmeAwTBbe"

# Seminar topics from csv file
SeminarTopics <- read.csv("Themenliste.csv") %>%
                      pull(String)


# --- Execution Function ---
post_to_fider <- function(point_text) {

  req <- request(paste0(BaseURL, "/api/v1/posts")) %>%
    req_headers(
      "Authorization" = paste("Bearer", Token),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(list(
      title = point_text,
      description = "",      # Optional: You can add more detail here
      categoryId = NULL      # Optional: Add integer ID if you have categories
    )) %>%
    req_retry(max_tries = 8) # Handles minor network blips

  # Perform the request
  resp <- req_perform(req)

  return(resp_status(resp))
}

# --- Run the Loop ---
# Using a simple loop to upload all points
results <- lapply(SeminarTopics, function(p) {
  message(paste("Uploading:", p))
  status <- "Error"
  try(status <- post_to_fider(p))
  Sys.sleep(0.5) # Short pause to avoid hitting rate limits
  return(status)
})

print("Upload complete!")


