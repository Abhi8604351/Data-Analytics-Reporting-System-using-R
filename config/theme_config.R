# --- Theme Configuration ---
# Standard Professional Look

LIGHT_THEME <- bs_theme(
  version = 5,
  bootswatch = "cerulean", # Clean, blue and white
  primary = "#007BFF",
  base_font = font_google("Inter"),
  heading_font = font_google("Outfit")
)

DARK_THEME <- bs_theme(
  version = 5,
  bootswatch = "darkly",
  primary = "#007BFF",
  base_font = font_google("Inter"),
  heading_font = font_google("Outfit")
)

# Initial Theme
CURRENT_THEME <- LIGHT_THEME
