# --- Server: Automated Model Engine Logic ---

server_model_engine <- function(input, output, session, session_data) {
  
  observeEvent(input$run_model, {
    req(session_data$raw_df)
    req(input$target_col)
    req(input$pred_cols)
    
    # Train/Test Split
    split_ratio <- input$train_split / 100
    df <- session_data$raw_df
    set.seed(42) # Reproducibility
    
    indices <- sample(1:nrow(df), size = floor(split_ratio * nrow(df)))
    train_data <- df[indices, ]
    test_data <- df[-indices, ]
    
    # --------------------------------------------------------
    # 1. Model Selection Logic
    # --------------------------------------------------------
    
    target_type <- detect_target_type(df[[input$target_col]])
    
    algo <- input$manual_algo
    if (input$auto_model) {
      algo <- select_optimal_algo(train_data, input$target_col, target_type)
    }
    
    # Execute Training
    results <- tryCatch({
       train_model(train_data, test_data, input$target_col, input$pred_cols, algo, target_type)
    }, error = function(e) {
       showNotification(paste("Modeling Error:", e$message), type = "error")
       return(NULL)
    })
    
    # Store results
    req(results)
    session_data$model_res <- results
    log_message(paste("Model trained using:", algo, "| Primary Metric:", results$metric_name, ":", results$metric_score))
  })
  
  # --------------------------------------------------------
  # 2. Output Visualizations
  # --------------------------------------------------------
  
  output$model_decision <- renderText({ 
    req(session_data$model_res)
    session_data$model_res$algo_name
  })
  
  output$model_score <- renderText({ 
    req(session_data$model_res)
    round(session_data$model_res$metric_score, 4)
  })
  
  output$model_status <- renderText({ 
    req(session_data$model_res)
    "Trained & Validated"
  })
  
  output$model_eval_plot <- renderPlotly({
    req(session_data$model_res)
    plot_model_performance(session_data$model_res)
  })
  
  output$importance_plot <- renderPlotly({
    req(session_data$model_res)
    plot_feature_importance(session_data$model_res)
  })
}

# --------------------------------------------------------
# 3. Decision Logic Helpers (Should be in modules/model_engine.R)
# --------------------------------------------------------

detect_target_type <- function(y) {
  if (is.numeric(y)) {
    if (length(unique(y)) < 11) "classification" else "regression"
  } else {
    "classification"
  }
}

select_optimal_algo <- function(df, target, type) {
  if (type == "regression") {
    if (nrow(df) > 1000 && ncol(df) > 5) "rf" else "lm"
  } else {
    if (length(unique(df[[target]])) == 2) "glm" else "rf"
  }
}
