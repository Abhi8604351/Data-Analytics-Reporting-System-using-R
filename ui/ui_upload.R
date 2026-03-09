# --- UI: Upload Page ---

ui_upload_page <- function() {
  div(
    class = "container py-5",
    fluidRow(
      # Main Upload Card
      column(
        width = 8,
        card(
          card_header(
            div(class = "d-flex align-items-center", 
                icon("cloud-arrow-up", class = "me-2"),
                "Secure Data Source Upload")
          ),
          card_body(
            p(class = "text-muted", "Accepts standard CSV/TXT files with automated delimiter detection."),
            
            fileInput("data_file", NULL, width = "100%", buttonLabel = "Select File"),
            
            layout_column_wrap(
                width = 1/2,
                checkboxInput("header", "Dataset has Header", TRUE),
                radioButtons("sep", "Column Delimiter:", choices = c(Comma = ",", Semicolon = ";", Tab = "\t"), inline = TRUE)
            ),
            
            hr(),
            uiOutput("upload_status"),
            
            card(
              card_header(class = "bg-light-subtle small", "Snapshot Preview (First 50 Rows)"),
              fillable = FALSE,
              DT::dataTableOutput("preview_table", height = "350px")
            )
          )
        )
      ),
      
      # Guidance Card
      column(
        width = 4,
        card(
          card_header(div(class = "d-flex align-items-center", icon("circle-question", class = "me-2"), "Quick Start Guide")),
          card_body(
            tags$ul(
              class = "list-unstyled",
              tags$li(class = "mb-2", icon("caret-right"), " Upload your raw CSV file."),
              tags$li(class = "mb-2", icon("caret-right"), " Check the preview to confirm structure."),
              tags$li(class = "mb-2", icon("caret-right"), " Navigate to 'Data Profiling' for health analysis."),
              tags$li(class = "mb-2", icon("caret-right"), " Use 'Insights' to generate a full report by ABHISHEK DINESH SINGH.")
            ),
            hr(),
            p(class = "small text-center", img(src = "logo.png", height = "50px", error = "SYSTEM OK"))
          )
        )
      )
    )
  )
}
