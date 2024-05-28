#........................dashboardHeader.........................
header <- dashboardHeader(
  
  # add title ----
  title = span("Mapping Tree Sensitivity", style = "font-size: 18px;")
  
) # END dashboardHeader


#........................dashboardSidebar........................
sidebar <- dashboardSidebar(
  
  # sidebarMenu ----
  sidebarMenu(
    
    menuItem(text = "About", tabName = "about", icon = icon("house")),
    menuItem(text = "Sensitivity Maps", tabName = "dashboard", icon = icon("leaf")),
    #menuItem(text = "Research", tabName = "research", icon = icon("lightbulb")),
    menuItem(text = "Data", tabName = "data", icon = icon("floppy-disk"))
    
  ) # END sidebarMenu
  
) # END dashboardSidebar

#..........................dashboardBody.........................


body <- dashboardBody(
  
  # header; load stylesheet & fontawesome kit ----
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "sass-styles.css"),
    tags$script(src = "https://kit.fontawesome.com/b7f4c476ba.js"),
    includeHTML("www/google-analytics.html")
  ), # END header
  
  # tabItems ----
  tabItems(
    
    # welcome tabItem ----
    tabItem(tabName = "about",
            
            # general project overview
            fluidRow(width = 12,
                     
                     # background box
                     box(width = 12,
                         includeMarkdown("text/background.md")
                     )),# END overview fluidRow

            # range map box ----
            fluidRow(width = 12,
                     
                     box(width = 12,
                         title = tagList(icon("earth-americas"), strong("Included Species Ranges")),
                         tags$img(src = "range_26.jpg", 
                              alt = "A Map of 26 species within a global context. A majority of our range is within the Northern Hemisphere.",
                              style = "max-width:80%; text-align: center;display: block; margin-left: auto; margin-right: auto;"))),
            
            # explore spp table ----
            fluidRow(width = 12,
                     box(width = 12,
                         title = tagList(icon("tree"), strong("Explore Mapped Tree Species")),
                         dataTableOutput("speciesTable")))
            
    ), # END about tabItem 
    
    # dashboard tabItem ----
    tabItem(tabName = "dashboard",
            
            # fluidRow ----
            fluidRow(
              
              # input box ----
              box(width = 8,
                  title = tagList(icon("tree"), strong("Mapping Tree Sensitivity")),
                  includeMarkdown("text/dashboard-about.md"),
                  #start flowLayout
                  flowLayout(
                    #"selectInputs here"
                    selectInput(inputId = "common_name_input",
                                label = "Common Name",
                                choices = c("Common Name"="", unique(combined_pred$common_name)),
                                multiple = FALSE,
                                selectize = TRUE,
                                width = NULL,
                                size = NULL),
                    selectInput(inputId = "sci_name_input",
                                label = "Scientific Name",
                                choices = c("Scientific Name"="",unique(combined_pred$scientific_name)),
                                multiple = FALSE,
                                selectize = TRUE,
                                width = NULL,
                                size = NULL),
                    selectInput(inputId = "sp_code_input",
                                label = "Species Code",
                                choices = c("4 Letter Code"="", unique(combined_pred$sp_code)),
                                multiple = FALSE,
                                selectize = TRUE,
                                width = NULL,
                                size = NULL)
                  ) # end selectInputs 
                  
              ),
              # END input box --
              # map interpretation box ---
              box(width = 4,
                  title = tags$strong("Transparency"),
                  includeMarkdown("text/transparency.md"),
                  sliderInput(inputId = "map_transparency_input",
                              label = NULL,
                              min = 0.1,
                              max = 0.9,
                              value = 0.8)
              ),
              
            ),# end of fluidRow
            fluidRow(
              # leaflet box ----
              box(width = 8,
                  
                  title = tags$strong("Tree Species Sensitivity to Drought"),
                  
                  # interactive map output ----
                  leafletOutput(outputId = "map_output")
                  
                  
                  
              ), # END leaflet box
              
              
              #), # END fluidRow
              tags$style(".small-box.bg-aqua { background-color: #A3b97b !important; color: #295a56 !important; }"),
              
              # map summary statistics box ---
              box(width = 4,
                  title = tags$strong("Summary Statistics"),
                  verticalLayout(
                    valueBoxOutput("max_sens_box", width = 12),
                    valueBoxOutput("min_sens_box",  width = 12),
                    valueBoxOutput("mean_sens_box",  width = 12)
                  )
              )# end interpretation box 
              
              
            )
            
    ), # END dashboard tabItem
    tabItem(tabName = "data",
            
            # fluidRow ----
            fluidRow(
              # input species box ----
              box(width = 8,
                  
                  title = tagList(icon("floppy-disk"), strong("Data")),
                  
                  includeMarkdown("text/download-instructions.md"),
                  
                  flowLayout(
                    pickerInput(inputId = "download_common_name_input",
                                label = "Common Name",
                                choices = c("Common Name"="", unique(combined_pred$common_name)),
                                multiple = TRUE),
                    selectInput(inputId = "download_sci_name_input",
                                label = "Scientific Name",
                                choices = c("Scientific Name"="",unique(combined_pred$scientific_name)),
                                multiple = TRUE),
                    selectInput(inputId = "download_sp_code_input",
                                label = "Species Code",
                                choices = c("Species Code"="", unique(combined_pred$sp_code)),
                                multiple = TRUE)
                  ) # END download picker inputs
                  
              ),# END input species box 
              box(width = 4,
                  # Button
                  "Click here to Download CSV",br(),
                  downloadButton("downloadData", "Download")
              )
              
            ),# END fluidRow
            # fluid row for example table
            fluidRow(
              box( width = 12,
                   DT::dataTableOutput(outputId = "data_table_output") %>% 
                     withSpinner(color = "#cb9e72", type = 1)
              )
            )
    ) # END data tabItem
    
  ) # END tabItems
  
) # END dashboardBody

#..................combine all in dashboardPage..................
dashboardPage(header, sidebar, body,
              fresh::use_theme("fresh-theme.css"))