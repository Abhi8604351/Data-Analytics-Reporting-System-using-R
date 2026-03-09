# --- Main UI Logic ---

ui_main <- page_navbar(
  title = APP_TITLE,
  theme = CURRENT_THEME,
  id = "main_nav",
  
  # Sidebar for Global Upload & Theme Toggle
  sidebar = sidebar(
    title = "System Control",
    fileInput("data_file", "Upload CSV File:", accept = ".csv", width = "100%"),
    checkboxInput("header", "Has Header", TRUE),
    radioButtons("sep", "Separator:", choices = c(Comma = ",", Semicolon = ";", Tab = "\t"), inline = TRUE),
    hr(),
    div(
      class = "text-center",
      actionButton("theme_toggle", "Toggle Dark/Light Mode", icon = icon("circle-half-stroke"))
    )
  ),
  
  # Main Display Panels
  nav_panel(
    title = "Dataset Overview",
    icon = icon("table"),
    fluidRow(
      column(
        width = 4,
        card(
          card_header("Dataset Metadata"),
          card_body(
              verbatimTextOutput("overview_text")
          )
        )
      ),
      column(
        width = 8,
        card(
          card_header("Missing Value Summary"),
          card_body(
              DT::dataTableOutput("missing_table")
          )
        )
      )
    ),
    card(
        card_header("Snapshot Preview (First 10 Rows)"),
        DT::dataTableOutput("preview_table")
    )
  ),
  
  nav_panel(
    title = "Statistical Analytics",
    icon = icon("chart-line"),
    layout_column_wrap(
      width = 1/2,
      card(
          card_header("Numeric Descriptive Statistics"),
          card_body(DT::dataTableOutput("numeric_stats"))
      ),
      card(
          card_header("Categorical Frequency Table"),
          card_body(
              selectInput("cat_col", "Select Categorical Variable:", choices = NULL),
              DT::dataTableOutput("freq_table")
          )
      )
    )
  ),
  
  nav_panel(
    title = "Visual Analytics",
    icon = icon("chart-simple"),
    navset_card_underline(
      nav_panel("Distributions (Numeric)", 
               selectInput("num_col_dist", "Select Variable:", choices = NULL),
               plotlyOutput("hist_plot")),
      nav_panel("Count (Categorical)", 
               selectInput("cat_col_bar", "Select Variable:", choices = NULL),
               plotlyOutput("bar_plot")),
      nav_panel("Outlier (Boxplot)", 
               selectInput("num_col_box", "Select Variable:", choices = NULL),
               plotlyOutput("box_plot")),
      nav_panel("Correlations", 
                plotlyOutput("cor_plot"))
    )
  ),
  
  nav_panel(
    title = "Written Summary & Report",
    icon = icon("file-pdf"),
    fluidRow(
      column(
        width = 7,
        card(
          card_header("Automated Written Summary"),
          card_body(
              htmlOutput("summary_paragraph")
          )
        )
      ),
      column(
        width = 5,
        card(
          card_header("Export Profession Report"),
          card_body(
            p("Generate a comprehensive PDF report including all visualizations and statistics."),
            hr(),
            downloadButton("download_pdf", "Download Professional PDF Report", class = "btn btn-primary w-100"),
            br(), br(),
            p(class = "text-center small opacity-75", paste("Engineered by", APP_AUTHOR))
          )
        )
      )
    )
  ),
  
  footer = div(
    class = "text-center p-3 border-top small",
    p(paste(APP_TITLE, "| Developed by", APP_AUTHOR))
  )
)
