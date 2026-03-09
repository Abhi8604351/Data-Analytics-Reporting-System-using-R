# --- Engine: Correlation & Multicollinearity Analysis ---

# 1. Main Calculation Logical Engine
compute_correlations <- function(df, cols) {
    req(length(cols) > 1)
    # Calculate pure correlation matrix
    cor_mat <- cor(df[, cols, drop = FALSE], use = "pairwise.complete.obs")
    return(cor_mat)
}

# 2. Extract Significant Associations
find_strong_pairs <- function(cor_mat, threshold = 0.7) {
    # Extract row/col where abs(val) > threshold and dist from diagonal
    strong <- which(abs(cor_mat) > threshold & lower.tri(cor_mat), arr.ind = TRUE)
    
    if (nrow(strong) > 0) {
        # Build readable output
        data.frame(
            Var1 = rownames(cor_mat)[strong[, 1]],
            Var2 = colnames(cor_mat)[strong[, 2]],
            Correlation = cor_mat[strong]
        )
    } else {
        NULL
    }
}
