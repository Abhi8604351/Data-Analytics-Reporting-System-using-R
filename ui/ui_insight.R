# --- UI: AI Insight Generation & Reporting Engine ---

ui_insight_page <- function() {
  div(
    class = "container py-4",
    
    fluidRow(
      column(
        width = 7,
        card(
          card_header(
            div(class = "d-flex justify-content-between align-items-center",
                span(icon("lightbulb"), " Intelligent Analysis Summary"),
                span(class = "badge bg-primary", "Live AI Generation"))
          ),
          card_body(
              htmlOutput("ai_insights"),
              hr(),
              card(
                card_header("Data Quality Score Metrics", class = "small bg-light"),
                card_body(
                    plotlyOutput("quality_gauge_viz", height = "300px")
                )
              )
          )
        )
      ),
      
      column(
        width = 5,
        card(
          card_header(div(class = "d-flex align-items-center", icon("file-pdf", class = "me-2"), "Report Distribution")),
          card_body(
              p("Export verified analytics results into a professional executive summary."),
              
              # Report Controls
              textInput("report_title", "Project Code / Title:", "Analytics Insight Report"),
              
              hr(),
              
              # Download Buttons
              div(class = "d-grid gap-2",
                  downloadButton("dl_pdf", "Generate PDF Report", class = "btn btn-primary"),
                  downloadButton("dl_html", "Generate Web Link (HTML)", class = "btn btn-outline-secondary"),
                  downloadButton("dl_cleaned_csv", "Export Cleaned Dataset", class = "btn btn-success")
              ),
              
              hr(),
              
              div(class = "text-center opacity-50 small mt-4",
                  p("Verified & Engineered by"),
                  h6("ABHISHEK DINESH SINGH"),
                  p("Intelligence Reporting Protocol v2.0")
              )
          )
        )
      )
    )
  )
}
