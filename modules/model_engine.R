# --- Engine: Automated Model Selection & Training ---

# 1. Main Training Entry Point
train_model <- function(train_df, test_df, target, predictors, algo, type) {
  
  # Safety: Remove target from predictors if selected
  predictors <- setdiff(predictors, target)
  
  if (length(predictors) == 0) {
      stop("Please select at least one predictor (X) that is not the target (Y).")
  }
  
  # Prepare Formula
  f <- as.formula(paste(target, "~", paste(predictors, collapse = "+")))
  
  # Result storage
  results <- list(
    algo_id = algo,
    target = target,
    predictors = predictors,
    type = type
  )
  
  # Method Switching
  if (algo == "lm") {
    model <- lm(f, data = train_df)
    preds <- predict(model, test_df)
    
    # Calculate Results
    rmse <- sqrt(mean((test_df[[target]] - preds)^2, na.rm = TRUE))
    r_squared <- summary(model)$r.squared
    
    results$model <- model
    results$algo_name <- "Linear Regression"
    results$metric_name <- "RMSE"
    results$metric_score <- rmse
    results$r_squared <- r_squared
  
  } else if (algo == "glm") {
    # Assume 2-level classification for GLM
    train_df[[target]] <- as.factor(train_df[[target]])
    model <- glm(f, data = train_df, family = binomial)
    preds <- predict(model, test_df, type = "response")
    
    # Simple Accuracy logic
    acc <- mean(ifelse(preds > 0.5, 1, 0) == test_df[[target]])
    
    results$model <- model
    results$algo_name <- "Logistic Regression"
    results$metric_name <- "Accuracy (%)"
    results$metric_score <- acc * 100
  
  } else if (algo == "rf") {
    if (type == "classification") {
      train_df[[target]] <- as.factor(train_df[[target]])
    }
    
    model <- randomForest(f, data = train_df, ntree = 100)
    preds <- predict(model, test_df)
    
    if (type == "regression") {
      rmse <- sqrt(mean((test_df[[target]] - preds)^2, na.rm = TRUE))
      results$metric_name <- "RMSE"
      results$metric_score <- rmse
    } else {
      # Accuracy for classification
      acc <- mean(preds == test_df[[target]])
      results$metric_name <- "Accuracy (%)"
      results$metric_score <- acc * 100
    }
    
    results$model <- model
    results$algo_name <- "Random Forest Engine"
    results$importance <- importance(model)
  }
  
  return(results)
}

# 2. Performance Visualization
plot_model_performance <- function(res) {
  # Generate diagnostic plot based on type
    plot_ly(x = c(res$algo_name), y = c(res$metric_score), type = "bar", 
            name = res$metric_name) %>%
        layout(title = paste("Model Evaluation Overview | Metric:", res$metric_name))
}

# 3. Feature Importance
plot_feature_importance <- function(res) {
    req(res$algo_id == "rf")
    imp_df <- data.frame(
        Feature = rownames(res$importance),
        Importance = res$importance[, 1]
    )
    
    plot_ly(imp_df, x = ~Importance, y = ~reorder(Feature, Importance), type = "bar", orientation = "h") %>%
        layout(title = "Feature Importance Ranking")
}
