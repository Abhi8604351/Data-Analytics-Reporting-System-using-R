# --- UI: Automated Model Selection & Training Engine ---

ui_model_page <- function() {
  div(
    class = "container py-4",
    layout_sidebar(
      sidebar = sidebar(
        title = "Model Configuration",
        
        # Target Selection
        selectizeInput("target_col", "Primary Target Variable (Y):", 
                       choices = NULL, multiple = FALSE, width = "100%"),
        
        # Feature Selection
        selectizeInput("pred_cols", "Predictor Features (X):", 
                       choices = NULL, multiple = TRUE, width = "100%"),
        
        # Auto-mode toggle
        switchInput("auto_model", "Auto-Engine Mode", value = TRUE, 
                   onLabel = "AUTO", offLabel = "MANUAL", width = "100%"),
        
        # Manual Mode Logic
        conditionalPanel(
          condition = "!input.auto_model",
          selectInput("manual_algo", "Algorithm Selection:", 
                      choices = c("Linear Regression" = "lm", "Logistic Regression" = "glm", "Random Forest" = "rf"))
        ),
        
        hr(),
        
        # Training Parameters
        sliderInput("train_split", "Train/Test Split (%):", min = 50, max = 95, value = 80, step = 5),
        
        actionButton("run_model", "Train & Evaluate Models", 
                     icon = icon("rocket"), class = "btn-success w-100 mt-3")
      ),
      
      div(
          # Model Results Header Overview
          layout_column_wrap(
            width = 1/3,
            value_box(
              title = "System Decision",
              value = textOutput("model_decision"),
              icon = icon("brain")
            ),
            value_box(
              title = "Primary Metric Score",
              value = textOutput("model_score"),
              icon = icon("gauge-high")
            ),
            value_box(
              title = "Model Status",
              value = textOutput("model_status"),
              icon = icon("check-circle")
            )
          ),
          
          # Detailed Model Analysis Tabs
          navset_card_tab(
            title = "Engine Evaluation Metrics",
            
            nav_panel("Performance Dashboard",
              div(
                card_body(
                    plotlyOutput("model_eval_plot", height = "450px")
                )
              )
            ),
            
            nav_panel("Feature Importance",
              div(
                card_body(
                    plotlyOutput("importance_plot", height = "450px")
                )
              )
            ),
            
            nav_panel("Error Analysis / Residuals",
              div(
                card_body(
                    plotlyOutput("residual_plot", height = "450px")
                )
              )
            )
          )
      )
    )
  )
}
