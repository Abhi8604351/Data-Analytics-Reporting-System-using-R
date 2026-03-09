# --- UI: Outlier Detection Engine ---

ui_outlier_page <- function() {
  div(
    class = "container py-4",
    layout_sidebar(
      sidebar = sidebar(
        title = "Detection Parameters",
        selectInput("outlier_method", "Detection Strategy:", 
                    choices = c("Interquartile Range (IQR)" = "iqr", "Z-Score Analysis" = "zscore")),
        
        # Strategy-specific inputs
        conditionalPanel(
          condition = "input.outlier_method == 'iqr'",
          numericInput("iqr_mult", "IQR Multiplier (k):", 1.5, min = 1, max = 5, step = 0.5)
        ),
        
        conditionalPanel(
          condition = "input.outlier_method == 'zscore'",
          numericInput("z_threshold", "Z-Score Threshold:", 3, min = 1, max = 5, step = 0.5)
        ),
        
        hr(),
        selectizeInput("outlier_cols", "Columns to Analyze:", choices = NULL, 
                      multiple = TRUE, width = "100%"),
        
        actionButton("run_outlier", "Analyze Outliers", class = "btn-primary w-100 mt-3")
      ),
      
      div(
          card(
            card_header("Outlier Analysis Report"),
            card_body(
                uiOutput("outlier_summary"),
                plotlyOutput("outlier_viz", height = "500px")
            )
          ),
          
          card(
              card_header("Identified Outlier Records"),
              card_body(
                  DT::dataTableOutput("outlier_table")
              )
          )
      )
    )
  )
}
