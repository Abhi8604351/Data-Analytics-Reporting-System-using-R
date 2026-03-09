# --- Engine: Outlier Detection Modules ---

# 1. Main Outlier Detection Engine
outlier_detect <- function(df, cols, method = "iqr", iqr_mult = 1.5, z_threshold = 3) {
  
  # Ensure columns are numeric
  df_numeric <- df[, cols, drop = FALSE]
  
  # Result storage
  outlier_indices <- list()
  
  # Method Switching
  if (method == "iqr") {
    
    for (col in cols) {
      q1 <- quantile(df_numeric[[col]], 0.25, na.rm = TRUE)
      q3 <- quantile(df_numeric[[col]], 0.75, na.rm = TRUE)
      iqr <- q3 - q1
      
      lower_bound <- q1 - (iqr_mult * iqr)
      upper_bound <- q3 + (iqr_mult * iqr)
      
      # Detect indices
      outliers <- which(df_numeric[[col]] < lower_bound | df_numeric[[col]] > upper_bound)
      outlier_indices[[col]] <- outliers
    }
    
  } else if (method == "zscore") {
    
    for (col in cols) {
      # Calculate Z-score
      z_scores <- (df_numeric[[col]] - mean(df_numeric[[col]], na.rm = TRUE)) / 
                 sd(df_numeric[[col]], na.rm = TRUE)
      
      # Detect indices
      outliers <- which(abs(z_scores) > z_threshold)
      outlier_indices[[col]] <- outliers
    }
  }
  
  # Collapse all unique indices
  unique_outliers <- unique(unlist(outlier_indices))
  
  # Return data
  return(list(
    outlier_indices = unique_outliers,
    outlier_subset = df[unique_outliers, ],
    clean_subset = df[-unique_outliers, ],
    metadata = list(
        total_found = length(unique_outliers),
        method = method
    )
  ))
}

# 2. Outlier Distribution Plot
plot_outliers <- function(outlier_res) {
    # Generate scatter plot highlighting outliers
    # For now, a simple boxplot of variables
    df <- outlier_res$outlier_subset
    
    # Simple summary visualization
    plot_ly(df, y = ~rownames(df), x = ~seq_len(nrow(df)), type = "scatter", mode = "markers") %>%
        layout(title = "Outlier Concentration Pattern")
}
