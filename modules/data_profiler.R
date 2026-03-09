# --- Engine: Data Profiler & Visualization Logic ---

# 1. Missing Value Patterns
plot_missing_patterns <- function(df) {
  missing_data <- colMeans(is.na(df)) * 100
  missing_df <- data.frame(Column = names(missing_data), PctMissing = missing_data)
  
  plot_ly(missing_df, x = ~Column, y = ~PctMissing, type = "bar",
          marker = list(color = "rgba(44, 62, 80, 0.7)")) %>%
    layout(title = "Missingness Percent by Column",
           yaxis = list(title = "Missing (%)"),
           xaxis = list(title = "Column Name"))
}

# 2. Correlation Matrix
plot_correlation_matrix <- function(df, cols) {
    req(length(cols) > 1)
    cor_mat <- cor(df[, cols, drop = FALSE], use = "pairwise.complete.obs")
    
    plot_ly(
        z = cor_mat,
        x = colnames(cor_mat),
        y = colnames(cor_mat),
        type = "heatmap",
        colorscale = "RdBu",
        zmin = -1, zmax = 1
    ) %>%
    layout(title = "Feature Correlation Insight Heatmap")
}

# 3. Distribution Analysis
plot_distribution <- function(df, col, show_density = TRUE) {
    req(col %in% colnames(df))
    x <- df[[col]]
    
    if (is.numeric(x)) {
        p <- plot_ly(x = x, type = "histogram", name = "Distribution",
                     marker = list(color = "rgba(33, 150, 243, 0.6)"))
        
        if (show_density) {
            # Simple densify overlay
            # p <- p %>% add_lines(y = ~density, ...)
        }
        
        p %>% layout(title = paste("Distribution Analyis:", col))
    } else {
        # Bar chart for categorical
        plot_ly(as.data.frame(table(x)), x = ~x, y = ~Freq, type = "bar",
                marker = list(color = "rgba(100, 150, 100, 0.5)")) %>%
        layout(title = paste("Frequency Analysis:", col))
    }
}
