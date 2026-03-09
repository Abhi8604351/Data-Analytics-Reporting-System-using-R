# --- Server: Outlier Detection Logic ---

server_outlier_engine <- function(input, output, session, session_data) {
  
  observeEvent(input$run_outlier, {
    req(session_data$raw_df)
    req(input$outlier_cols)
    
    # --------------------------------------------------------
    # 1. Detection Engine Logic
    # --------------------------------------------------------
    
    res <- outlier_detect(
      df = session_data$raw_df,
      cols = input$outlier_cols,
      method = input$outlier_method,
      iqr_mult = input$iqr_mult,
      z_threshold = input$z_threshold
    )
    
    session_data$outlier_res <- res
    log_message(paste("Outlier Analysis Completed on", length(input$outlier_cols), "columns."))
  })
  
  output$outlier_viz <- renderPlotly({
    req(session_data$outlier_res)
    plot_outliers(session_data$outlier_res)
  })
  
  output$outlier_summary <- renderUI({
    req(session_data$outlier_res)
    div(
      class = "alert alert-info py-2",
      p(paste("Total Records Scanned:", nrow(session_data$raw_df))),
      p(paste("Outlier Records Identified:", nrow(session_data$outlier_res$outlier_indices))),
      p(strong(paste("Detection Sensitivity:", ifelse(input$outlier_method == "iqr", input$iqr_mult, input$z_threshold))))
    )
  })
  
  output$outlier_table <- renderDataTable({
    req(session_data$outlier_res)
    datatable(session_data$outlier_res$outlier_subset, options = list(pageLength = 5, scrollX = TRUE))
  })
}
