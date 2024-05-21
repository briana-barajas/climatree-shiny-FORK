## ClimaTree Dashboard 💻
Shiny App Development for ClimaTree

## About the ClimaTree Dashboard 🗺️

This repository contains code that was used to create the interactive dashboard for the ClimaTree project. The envisioned audiences for this dashboard are land managers, policy makers or others simply curious about the topic. The main functions of this dashboard are to display both sensitivity and vulnerability (future growth prediction) maps of individual species. The user can choose which species and what type of map to look at, as well as interact with each map to get specific values and locations. The data used to create these maps is available for download in table format from the dashboard. 

## Repository structure:

  
    ├── scratch/                                          # scripts for trying out visuals, analyses, etc. before adding to the app
    │   └── 
    |── shinydashboard/                                   # folder containing the code for App #3, a shinydashboard 
    |   └── global.R                                        # packages, objects, etc. used by ui & server
    |   └── ui.R                                            # user interface code
    |   └── server.R                                        # server code
    |   └── data/                                         # folder containing pre-processed data used by the app
    |     └── combined_pred.csv                       # processed data (.csv) (raw file in ~/raw_data, processing script in ~/R/data_processing_app3_shinydashboard.R)
    |   └── text/                                         # folder containing markdown files with styled text embedded in app
    |     └── approach.md                                   # welcome page approach info text      
    |     └── background.md                                 # welcome page background citation text
    |     └── dashboard-about.md                            # welcome page dashboard explanaition text
    |     └── mapping-tree-vulnerabilty.md                  # welcome page mapping tree text
    |     └── research.md                                   # welcome pagge research info text
    |   └── www/                                          # special directory in shiny for images, stylesheets, etc. 
    |      └── sass-style.css                               # generate css style sheet
    |      └── sass-style.scss                              # sass style sheet                         
