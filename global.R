# --- Automatic CSV Data Analysis & Report Generator ---
# Global Dependency & Module Sourcing

# 0. Set Local Library Path
LOCAL_LIB <- "R_library"
if (dir.exists(LOCAL_LIB)) {
  .libPaths(c(normalizePath(LOCAL_LIB), .libPaths()))
}

# 1. Load Essential Libraries
library(shiny)
library(bslib)
library(tidyverse)
library(plotly)
library(DT)
library(corrplot)
library(rmarkdown)
library(knitr)
library(shinyWidgets)

# 2. Source Configuration
source("config/settings.R")
source("config/theme_config.R")

# 3. Source UI Logic
source("ui/ui_main.R")

# 4. Source Server & Analytical Logic
source("server/server_main.R")
source("reports/report_generator.R")
