# --- Intelligent Automated Data Analytics & Reporting System ---
# Main Application Shell

# Source global logic
source("global.R")

# Main Shiny UI definition
ui <- ui_main

# Main Shiny Server function
server <- function(input, output, session) {
  # Initialize server-side logic
  server_main(input, output, session)
}

# Launch the Application
shinyApp(ui = ui, server = server)
