# load libraries ----
library(fresh)

# create theme ----
create_theme(
  
  # change "light-blue"/"primary" color
  adminlte_color(
    light_blue = "#4a5342" # sage green
  ),
  
  # dashboardBody styling (includes boxes)
  adminlte_global(
    content_bg = "#78866b" # grey green
  ),
  
  # dashboardSidebar styling
  adminlte_sidebar(
    width = "300px", 
    dark_bg = "#364030", # sagegreen
    dark_hover_bg = "#A3b97b", # magenta
    dark_color = "white" # red
  ),
  output_file = "www/fresh-theme.css" # generate css file & save to www/
)