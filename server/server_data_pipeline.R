# --- Server: Data Pipeline Engine ---

server_data_pipeline <- function(input, output, session, session_data) {
  
  # --------------------------------------------------------
  # 1. File Upload & Raw Data Detection
  # --------------------------------------------------------
  
  observeEvent(input$data_file, {
    req(input$data_file)
    
    # Read CSV with user options
    tryCatch({
      raw_df <- read.csv(
        input$data_file$datapath, 
        header = input$header, 
        sep = input$sep, 
        quote = '"',
        stringsAsFactors = FALSE
      )
      
      # Clean names for R compatibility
      colnames(raw_df) <- make.names(colnames(raw_df), unique = TRUE)
      
      # Store and Log
      session_data$raw_df <- raw_df
      session_data$clean_df <- raw_df # Initial Clean state
      log_message(paste("Uploaded File:", input$data_file$name, "| Rows:", nrow(raw_df)))
      
      # Perform profiling
      perform_profiling(session_data)
      
      # Update UI Selectors
      update_column_selectors(session, session_data)
      
      # Status Message
      output$upload_status <- renderUI({
        div(class = "alert alert-success d-flex align-items-center mb-3",
           icon("check-circle", class = "me-2"),
           p(class = "mb-0", sprintf("Success! Dataset detected with %d rows and %d variables.", nrow(raw_df), ncol(raw_df)))
        )
      })
      
    }, error = function(e) {
      showNotification(paste("File Error:", e$message), type = "error")
    })
  })
  
  # --------------------------------------------------------
  # 2. Preview Table & Metadata
  # --------------------------------------------------------
  
  output$preview_table <- DT::renderDataTable({
    req(session_data$raw_df)
    datatable(
      head(session_data$raw_df, 50), 
      options = list(scrollX = TRUE, pageLength = 5, dom = 'Bfrtip'),
      class = "table table-hover"
    )
  })
  
  output$row_count <- renderText({ req(session_data$raw_df); nrow(session_data$raw_df) })
  output$col_count <- renderText({ req(session_data$raw_df); ncol(session_data$raw_df) })
  
  output$missing_perc <- renderText({ 
    req(session_data$metadata$missing_ratio)
    sprintf("%.1f%%", session_data$metadata$missing_ratio * 100)
  })
  
  output$quality_score <- renderText({
    req(session_data$raw_df)
    # Call the engine
    score_res <- compute_overall_quality(session_data$raw_df)
    sprintf("%.0f/100", score_res$total)
  })
  
  # --------------------------------------------------------
  # 3. Profiling Visualizations
  # --------------------------------------------------------
  
  output$missing_plot <- renderPlotly({
    req(session_data$raw_df)
    plot_missing_patterns(session_data$raw_df)
  })
  
  output$cor_plot <- renderPlotly({
    req(session_data$raw_df)
    cols <- input$cor_cols
    req(length(cols) > 1)
    plot_correlation_matrix(session_data$raw_df, cols)
  })
  
  output$dist_plot <- renderPlotly({
    req(session_data$raw_df)
    req(input$dist_col)
    plot_distribution(session_data$raw_df, input$dist_col, input$show_density)
  })
  
  output$summary_stats_table <- DT::renderDataTable({
    req(session_data$raw_df)
    df <- session_data$raw_df
    
    stats <- data.frame(
      Variable = names(df),
      Type = sapply(df, class),
      Missing = colSums(is.na(df)),
      Unique = sapply(df, function(x) length(unique(x)))
    )
    
    datatable(stats, options = list(pageLength = 10, dom = 'tip'), class = "table table-striped table-sm")
  })
}

# --------------------------------------------------------
# 4. Shared Update Helper
# --------------------------------------------------------

update_column_selectors <- function(session, sd) {
  req(sd$raw_df)
  all_cols <- colnames(sd$raw_df)
  num_cols <- colnames(sd$raw_df)[sapply(sd$raw_df, is.numeric)]
  
  # Profiling Page Selectors
  updateSelectizeInput(session, "cor_cols", choices = num_cols, selected = head(num_cols, 5))
  updateSelectizeInput(session, "dist_col", choices = all_cols, selected = head(all_cols, 1))
  
  # Outlier Page Selectors
  updateSelectizeInput(session, "outlier_cols", choices = num_cols, selected = head(num_cols, 1))
  
  # Model Page Selectors
  updateSelectizeInput(session, "target_col", choices = all_cols)
  updateSelectizeInput(session, "pred_cols", choices = all_cols)
}

perform_profiling <- function(sd) {
  # Logic to extract metadata and stats (could be moved to module)
  sd$metadata <- list(
    row_count = nrow(sd$raw_df),
    col_count = ncol(sd$raw_df),
    missing_ratio = sum(is.na(sd$raw_df)) / (nrow(sd$raw_df) * ncol(sd$raw_df))
  )
}
