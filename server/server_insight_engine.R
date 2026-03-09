# --- Server: AI Insight & Reporting Logic ---

server_insight_engine <- function(input, output, session, session_data) {
  
  # --------------------------------------------------------
  # 1. Automatic Insight Trigger
  # --------------------------------------------------------
  
  observe({
    req(session_data$raw_df)
    
    # Analyze Dataset Profiles
    insights <- generate_automated_insights(session_data)
    session_data$insights <- insights
  })
  
  output$ai_insights <- renderUI({
    req(session_data$insights)
    
    insight_html <- tagList(
      h4("Automated Executive Summary", class = "mb-3"),
      # Display generated paragraphs
      lapply(session_data$insights, function(ins) {
        div(
          class = "alert alert-light border-start-primary mb-2 shadow-sm",
          icon("check-circle", class = "text-primary me-2"),
          span(ins$text)
        )
      })
    )
    
    insight_html
  })
  
  output$quality_gauge_viz <- renderPlotly({
    req(session_data$raw_df)
    plot_quality_gauge(session_data$raw_df)
  })
  
  # --------------------------------------------------------
  # 2. Report Download Handlers
  # --------------------------------------------------------
  
  output$dl_pdf <- downloadHandler(
    filename = function() { paste0(input$report_title, "_", Sys.Date(), ".pdf") },
    content = function(file) {
      req(session_data$raw_df)
      generate_report(file, session_data, "pdf", input$report_title)
    }
  )
  
  output$dl_html <- downloadHandler(
    filename = function() { paste0(input$report_title, "_", Sys.Date(), ".html") },
    content = function(file) {
      req(session_data$raw_df)
      generate_report(file, session_data, "html", input$report_title)
    }
  )
  
  output$dl_cleaned_csv <- downloadHandler(
      filename = function() { paste0("Cleaned_", input$data_file$name) },
      content = function(file) {
          write.csv(session_data$clean_df, file, row.names = FALSE)
      }
  )
}
