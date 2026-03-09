Intelligent Automated Data Analytics & Reporting System

An enterprise-grade Shiny platform for automated statistical profiling, outlier detection, predictive modeling, and executive reporting.
Key Features

- Dynamic Data Pipeline: Supports any CSV/TXT upload with automated schema detection.
- Automated Profiling: Real-time missingness analysis, correlation heatmaps, and distribution insights.
- Outlier Engine: Integrated IQR and Z-score detection with interactive visualization.
- Predictive Engine: Automated target detection (Classification vs. Regression) and optimal algorithm selection (LM, GLM, Random Forest).
- Rule-Based Insights: AI-driven narrative generation for skewness, correlation, and data quality alerts.
- Professional Reporting: Generate comprehensive PDF and HTML reports with embedded charts and model metrics.
- Modern UI: Built with `bslib` for dark/light mode switching and responsive layouts.

Architectural Structure

The project follows a strict separation of concerns to ensure scalability and maintainability:

| Directory | Responsibility |
|-----------|----------------|
| `config/` | Application constants, limits, and theme definitions. |
| `ui/` | Pure UI component definitions (Modularized pages). |
| `server/` | Server-side orchestration and reactivity management. |
| `modules/` | Core analytical engines and pure mathematical functions. |
| `reports/` | RMarkdown templates and generation logic. |
| `utils/` | Logging, validation, performance optimization, and helpers. |
| `assets/` | Static CSS, JS, and image assets. |

Technology Stack

- Core:R (v4.0+)
- Framework: Shiny
- UI System: bslib, shinyWidgets, bootstrap 5
- Interactive Viz: plotly, DT, corrplot
- Analysis: tidyverse, randomForest, broom
- Reporting: rmarkdown, knitr, kableExtra


1. Ensure R and RStudio are installed.
2. Install required dependencies:
   ```R
   install.packages(c("shiny", "bslib", "tidyverse", "plotly", "DT", "randomForest", "rmarkdown", "shinyWidgets", "logger", "corrplot", "broom"))
   ```
3. Open `app.R` and click Run App.

---
Developed for High-Performance Enterprise Analytics.
