# --- Utility: Data Validation Engine ---

# 1. Main File Quality Check
validate_file_integrity <- function(datapath) {
  # Perform initial read
  res <- tryCatch({
    df <- read.csv(datapath, nrows = 5)
    list(success = TRUE, message = "File format detected correctly.")
  }, error = function(e) {
    list(success = FALSE, message = paste("Integrity Failure:", e$message))
  })
  
  return(res)
}

# 2. Schema Compatibility Check
validate_schema <- function(df, target) {
    if (is.null(df)) return(FALSE)
    if (!(target %in% colnames(df))) return(FALSE)
    return(TRUE)
}
