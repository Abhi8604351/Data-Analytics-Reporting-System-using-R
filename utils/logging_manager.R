# --- Utility: Professional Logging Manager ---

# Initialize Logger
if (!dir.exists("logs")) dir.create("logs")

# 1. Main Logging Handler
log_message <- function(msg, level = "INFO", component = "SYSTEM") {
    
    # Simple console output
    cat(sprintf("[%s] [%s] [%s] %s\n", Sys.time(), level, component, msg))
    
    # Store to file
    try({
        write(
            sprintf("[%s] [%s] [%s] %s", Sys.time(), level, component, msg),
            file = "logs/app_log.txt",
            append = TRUE
        )
    }, silent = TRUE)
}

# 2. Performance Profiling (Start/End)
log_perf_start <- function(task) {
    log_message(paste("STARTING TASK:", task), level = "PERF")
    return(Sys.time())
}

log_perf_end <- function(task, start_time) {
    duration <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
    log_message(paste("COMPLETED TASK:", task, "| Duration:", round(duration, 3), "s"), level = "PERF")
}
