# --- Utility: Performance & Memory Optimization ---

# 1. Memory Cleanup Logic
memory_cleanup <- function() {
    # Force Garbage Collection
    gc()
}

# 2. Large Data Handling Flag
handle_large_data <- function(df, threshold = 100000) {
    if (nrow(df) > threshold) {
        # Apply lazy loading strategies or data reduction
        return(TRUE)
    }
    return(FALSE)
}

# 3. Dynamic Optimization Parameters
get_opt_params <- function(df) {
    n <- nrow(df)
    c <- ncol(df)
    
    if (n > 50000) {
        list(use_dtplyr = TRUE, parallel_op = TRUE)
    } else {
        list(use_dtplyr = FALSE, parallel_op = FALSE)
    }
}
