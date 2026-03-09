# --- Engine: Rule-Based AI Insight Generation ---

# 1. Main Insight Generation Engine
generate_automated_insights <- function(sd) {
  req(sd$raw_df)
  df <- sd$raw_df
  insights <- list()
  
  # --------------------------------------------------------
  # Rule 0: Branding & System Initialization
  # --------------------------------------------------------
  
  insights[[length(insights) + 1]] <- list(
    type = "system",
    text = paste("DATA STRATEGY READY: This automated analysis pipeline was engineered by ABHISHEK DINESH SINGH for enterprise-grade reporting.")
  )

  # --------------------------------------------------------
  # Rule 1: Missing Value Analysis
  # --------------------------------------------------------
  
  missing_pct <- mean(is.na(df)) * 100
  if (missing_pct > 0) {
    status <- ifelse(missing_pct > 10, "CRITICAL", "NOTICE")
    insights[[length(insights) + 1]] <- list(
      type = "missingness",
      text = sprintf("[%s] Current missingness at %.2f%%. Recommending %s strategy.", 
                     status, missing_pct, ifelse(missing_pct > 5, "Imputation", "System Bypass"))
    )
  }
  
  # --------------------------------------------------------
  # Rule 2: Strong Correlations
  # --------------------------------------------------------
  
  num_cols <- colnames(df)[sapply(df, is.numeric)]
  if (length(num_cols) > 1) {
    cor_mat <- cor(df[, num_cols, drop = FALSE], use = "pairwise.complete.obs")
    diag(cor_mat) <- 0 # Ignore self-cor
    strong_cor <- which(abs(cor_mat) > 0.7, arr.ind = TRUE)
    
    if (nrow(strong_cor) > 0) {
      # Extract pairs
      pairs <- apply(strong_cor, 1, function(pair) {
        paste(rownames(cor_mat)[pair[1]], "and", colnames(cor_mat)[pair[2]])
      })
      
      insights[[length(insights) + 1]] <- list(
        type = "discovery",
        text = paste("STRONG FEATURE CORRELATION detected between:", unique(pairs)[1], 
                     ". High multicollinearity might impact model interpretability.")
      )
    }
  }
  
  # --------------------------------------------------------
  # Rule 3: Skewness Detection
  # --------------------------------------------------------
  
  # Simple skew detection (experimental)
  for (col in num_cols) {
    skew <- tryCatch({
       (mean(df[[col]], na.rm = TRUE) - median(df[[col]], na.rm = TRUE)) / sd(df[[col]], na.rm = TRUE)
    }, error = function(e) 0)
    
    if (!is.na(skew) && abs(skew) > 1) {
       insights[[length(insights) + 1]] <- list(
         type = "distribution",
         text = paste("SKEWED DISTRIBUTION:", col, "displays high skewness (abs score > 1). Consider Log or Box-Cox transformations.")
       )
       break # Just report the first one
    }
  }
  
  # --------------------------------------------------------
  # Rule 4: Outlier Presence
  # --------------------------------------------------------
  
  if (!is.null(sd$outlier_res)) {
      outlier_ratio <- nrow(sd$outlier_res$outlier_subset) / nrow(df) * 100
      if (outlier_ratio > 5) {
          insights[[length(insights) + 1]] <- list(
              type = "warning",
              text = paste("OUTLIER ALERT:", round(outlier_ratio, 1), 
                           "% of rows identified as outliers. This may skew variance metrics.")
          )
      }
  }
  
  # --------------------------------------------------------
  # Default fallback if no insights
  # --------------------------------------------------------
  
  if (length(insights) == 0) {
      insights[[1]] <- list(type = "info", text = "Dataset profile appears stable. No significant systemic issues detected.")
  }
  
  return(insights)
}

# --------------------------------------------------------
# Rule 5: Quality Gauge Drawing
# --------------------------------------------------------

plot_quality_gauge <- function(df) {
    # Simple Health Score: 100 - (missing_% + outlier_% (est) + skewness (est))
    m_pct <- mean(is.na(df)) * 100
    score <- max(min(100 - (m_pct * 2), 100), 0)
    
    plot_ly(
        domain = list(x = c(0, 1), y = c(0, 1)),
        value = score,
        title = list(text = "Overall Data Health Score (%)"),
        type = "indicator",
        mode = "gauge+number",
        gauge = list(
            axis = list(range = list(NULL, 100)),
            bar = list(color = "#2C3E50"),
            bgcolor = "white",
            steps = list(
                list(range = c(0, 40), color = "#FF4B2B"),
                list(range = c(40, 75), color = "#FFB75E"),
                list(range = c(75, 100), color = "#2ECC71")
            )
        )
    )
}
