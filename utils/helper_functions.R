# --- Utility: Dataset Helper Functions ---

# 1. Automated Schema Mapping
detect_schema <- function(df) {
  # Analyze each column
  lapply(df, function(col) {
    if (is.numeric(col)) {
      if (length(unique(col)) < 11) "cat" else "num"
    } else {
      "cat"
    }
  })
}

# 2. Simple Cleaning Pipeline
clean_dataset <- function(df, handle_na = "keep", drop_dup = TRUE) {
  # Remove duplicates
  if (drop_dup) {
    df <- df[!duplicated(df), ]
  }
  
  # Return cleaned
  return(df)
}

# 3. Numeric Formatting for Reports
fmt_num <- function(x, digits = 2) {
    if (is.numeric(x)) round(x, digits) else x
}
