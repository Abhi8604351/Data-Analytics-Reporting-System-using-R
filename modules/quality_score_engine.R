# --- Engine: Data Quality Scoring Analytics ---

# 1. Main Quality Score Core Engine
compute_overall_quality <- function(df) {
  
  # Initialize Components
  n_rows <- nrow(df)
  n_cols <- ncol(df)
  total_cells <- n_rows * n_cols
  
  # Metric 1: Completeness (1 - Missing %)
  missing_pct <- mean(is.na(df))
  completeness_score <- (1 - missing_pct) * 100
  
  # Metric 2: Uniqueness (1 - Duplicate Ratio)
  duplicate_ratio <- sum(duplicated(df)) / n_rows
  uniqueness_score <- (1 - duplicate_ratio) * 100
  
  # Metric 3: Variance/Information (Non-zero var columns)
  num_cols <- colnames(df)[sapply(df, is.numeric)]
  if (length(num_cols) > 0) {
      zero_var <- sum(sapply(df[, num_cols, drop = FALSE], function(x) sd(x, na.rm = TRUE) == 0), na.rm = TRUE)
      information_score <- (1 - (zero_var / length(num_cols))) * 100
  } else {
      information_score <- 100 # No numeric to judge variance
  }
  
  # Metric 4: Record Count Sufficiency
  rows_score <- min((n_rows / 100) * 100, 100) # Simple scaling
  
  # Weighted Average Summary Score
  total_score <- (completeness_score * 0.4) + (uniqueness_score * 0.2) + 
                   (information_score * 0.2) + (rows_score * 0.2)
  
  return(list(
    total = total_score,
    detail = list(
        completeness = completeness_score,
        uniqueness = uniqueness_score,
        information = information_score,
        rows = rows_score
    )
  ))
}
