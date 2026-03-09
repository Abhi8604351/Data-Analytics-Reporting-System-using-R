# --- UI: Data Profiling & Visualization Page ---

ui_profiling_page <- function() {
  div(
    class = "container-fluid py-4",
    
    # Overview Statistics Grid
    layout_column_wrap(
      width = 1/4,
      value_box(
        title = "Total Row Count",
        value = textOutput("row_count"),
        showcase = bs_icon("table"),
        theme = "primary"
      ),
      value_box(
        title = "Total Column Count",
        value = textOutput("col_count"),
        showcase = bs_icon("columns-gap"),
        theme = "info"
      ),
      value_box(
        title = "Missing Values (%)",
        value = textOutput("missing_perc"),
        showcase = bs_icon("percent"),
        theme = "warning"
      ),
      value_box(
        title = "Quality Score",
        value = textOutput("quality_score"),
        showcase = bs_icon("shield-check"),
        theme = "success"
      )
    ),
    
    hr(),
    
    # Interactive Content Sections
    navset_card_tab(
      title = div(class = "d-flex align-items-center", icon("magnifying-glass-chart", class = "me-2"), "Advanced Dataset Explorion"),
      
      nav_panel("Correlation Heatmap",
        card_body(
          div(class = "alert alert-light border-0 py-1 small italic", "Select numeric variables to explore statistical relationships."),
          selectizeInput("cor_cols", NULL, 
                         choices = NULL, multiple = TRUE, width = "100%", options = list(placeholder = 'Select Variables...')),
          plotlyOutput("cor_plot", height = "500px")
        )
      ),
      
      nav_panel("Feature Distributions",
        card_body(
          layout_column_wrap(
            width = 1/2,
            selectizeInput("dist_col", "Explore Variable:", choices = NULL, width = "100%"),
            checkboxInput("show_density", "Overlay Probability Density", TRUE)
          ),
          plotlyOutput("dist_plot", height = "450px")
        )
      ),
      
      nav_panel("Raw Variable Stats",
        DT::dataTableOutput("summary_stats_table")
      )
    )
  )
}
