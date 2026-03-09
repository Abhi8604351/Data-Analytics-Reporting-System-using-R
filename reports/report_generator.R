# --- Reporting Engine Logic ---

# 1. Main Report Generator Function
generate_report <- function(file, session_data, format = "pdf", title = "Data Report") {
  
  # Ensure template exists
  # Check if template file exists or create inline
  
  # Template definition path
  template_path <- "reports/report_template.Rmd"
  
  # Output file spec
  output_format <- ifelse(format == "pdf", "pdf_document", "html_document")
  
  # Render the markdown with parameters
  rmarkdown::render(
    input = template_path,
    output_file = file,
    params = list(
        report_title = title,
        raw_df = session_data$raw_df,
        metadata = session_data$metadata,
        insights = session_data$insights,
        model_res = session_data$model_res
    ),
    output_format = output_format,
    envir = new.env(parent = globalenv())
  )
}
