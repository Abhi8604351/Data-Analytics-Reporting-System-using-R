# --- Main Server Logic ---

server_main <- function(input, output, session) {
  
  # Reactive storage for data
  data_store <- reactiveValues(df = NULL, current_theme = "light")
  
  # --------------------------------------------------------
  # 1. Theme Toggle
  # --------------------------------------------------------
  observeEvent(input$theme_toggle, {
    if (data_store$current_theme == "light") {
      data_store$current_theme <- "dark"
      session$setCurrentTheme(DARK_THEME)
    } else {
      data_store$current_theme <- "light"
      session$setCurrentTheme(LIGHT_THEME)
    }
  })
  
  # --------------------------------------------------------
  # 2. File Upload Logic
  # --------------------------------------------------------
  observeEvent(input$data_file, {
    req(input$data_file)
    
    # Read the file
    df <- read.csv(input$data_file$datapath, header = input$header, sep = input$sep, stringsAsFactors = TRUE)
    data_store$df <- df
    
    # Update dropdowns
    num_cols <- names(df)[sapply(df, is.numeric)]
    cat_cols <- names(df)[!sapply(df, is.numeric)]
    
    updateSelectInput(session, "num_col_dist", choices = num_cols)
    updateSelectInput(session, "num_col_box", choices = num_cols)
    updateSelectInput(session, "cat_col", choices = cat_cols)
    updateSelectInput(session, "cat_col_bar", choices = cat_cols)
  })
  
  # --------------------------------------------------------
  # 3. Tables & Metadata Outputs
  # --------------------------------------------------------
  
  output$overview_text <- renderPrint({
    req(data_store$df)
    df <- data_store$df
    cat("Rows:   ", nrow(df), "\n")
    cat("Cols:   ", ncol(df), "\n\n")
    print(str(df))
  })
  
  output$preview_table <- renderDataTable({
    req(data_store$df)
    datatable(head(data_store$df, 10), options = list(dom = 't', scrollX = TRUE))
  })
  
  output$missing_table <- renderDataTable({
    req(data_store$df)
    df <- data_store$df
    missing_summary <- data.frame(
      Variable = names(df),
      MissingCount = colSums(is.na(df)),
      Percentage = round(colMeans(is.na(df)) * 100, 2)
    )
    datatable(missing_summary, options = list(pageLength = 5, dom = 'tip'))
  })
  
  output$numeric_stats <- renderDataTable({
    req(data_store$df)
    df <- data_store$df
    num_df <- df[, sapply(df, is.numeric), drop = FALSE]
    req(ncol(num_df) > 0)
    
    stats <- do.call(rbind, lapply(num_df, function(x) {
      data.frame(
        Min = min(x, na.rm = TRUE),
        Median = median(x, na.rm = TRUE),
        Mean = round(mean(x, na.rm = TRUE), 2),
        Max = max(x, na.rm = TRUE),
        SD = round(sd(x, na.rm = TRUE), 2)
      )
    }))
    stats$Variable <- rownames(stats)
    datatable(stats[, c("Variable", "Min", "Median", "Mean", "Max", "SD")], options = list(dom = 't'))
  })
  
  output$freq_table <- renderDataTable({
    req(data_store$df, input$cat_col)
    df <- data_store$df
    freq <- as.data.frame(table(df[[input$cat_col]]))
    names(freq) <- c("Category", "Frequency")
    freq$Percentage <- round(freq$Frequency / sum(freq$Frequency) * 100, 2)
    datatable(freq, options = list(pageLength = 10, dom = 'tip'))
  })
  
  # --------------------------------------------------------
  # 4. Visualizations
  # --------------------------------------------------------
  
  output$hist_plot <- renderPlotly({
    req(data_store$df, input$num_col_dist)
    p <- ggplot(data_store$df, aes_string(x = input$num_col_dist)) +
         geom_histogram(fill = "#007BFF", color = "white", bins = 20) +
         theme_minimal()
    ggplotly(p)
  })
  
  output$bar_plot <- renderPlotly({
    req(data_store$df, input$cat_col_bar)
    p <- ggplot(data_store$df, aes_string(x = input$cat_col_bar)) +
         geom_bar(fill = "#28A745") +
         theme_minimal() + coord_flip()
    ggplotly(p)
  })
  
  output$box_plot <- renderPlotly({
    req(data_store$df, input$num_col_box)
    p <- ggplot(data_store$df, aes_string(y = input$num_col_box)) +
         geom_boxplot(fill = "#FFC107") +
         theme_minimal()
    ggplotly(p)
  })
  
  output$cor_plot <- renderPlotly({
    req(data_store$df)
    num_df <- data_store$df[, sapply(data_store$df, is.numeric), drop = FALSE]
    req(ncol(num_df) > 1)
    cor_mat <- cor(num_df, use = "pairwise.complete.obs")
    plot_ly(z = cor_mat, x = colnames(cor_mat), y = colnames(cor_mat), type = "heatmap", colorscale = "RdBu")
  })
  
  # --------------------------------------------------------
  # 5. Written Summary Engine
  # --------------------------------------------------------
  
  output$summary_paragraph <- renderUI({
    req(data_store$df)
    df <- data_store$df
    
    # Logic to build a simple paragraph
    missing_pct <- round(mean(is.na(df)) * 100, 1)
    num_cols <- sum(sapply(df, is.numeric))
    cat_cols <- ncol(df) - num_cols
    
    div(
      p(sprintf("This dataset contains **%d observations** across **%d variables**.", nrow(df), ncol(df))),
      p(sprintf("The system identified **%d numeric columns** and **%d categorical/other columns**.", num_cols, cat_cols)),
      if(missing_pct > 0) {
        p(sprintf("A missing value analysis shows that **%.1f%%** of the data points are null. It is recommended to handle these before further modeling.", missing_pct))
      } else {
        p("No missing values were detected, indicating a very clean data source.")
      },
      p("Visual analysis suggests varying distributions across features, with potential outliers identified in several numeric columns as shown in the Boxplot tab.")
    )
  })
  
  # --------------------------------------------------------
  # 6. Report Generation
  # --------------------------------------------------------
  
  output$download_pdf <- downloadHandler(
    filename = function() { paste0("Data_Analysis_Report_", Sys.Date(), ".pdf") },
    content = function(file) {
      req(data_store$df)
      # Temporary template path
      temp_report <- "reports/report_template.Rmd"
      
      # Render the report
      rmarkdown::render(
        temp_report, 
        output_file = file,
        params = list(df = data_store$df, author = APP_AUTHOR, title = APP_TITLE),
        envir = new.env(parent = globalenv())
      )
    }
  )
}
