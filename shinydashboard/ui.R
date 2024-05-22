#........................dashboardHeader.........................
header <- dashboardHeader(
  
  # add title ----
  title = span("Mapping Tree Vulnerablity", style = "font-size: 18px;")

) # END dashboardHeader


#........................dashboardSidebar........................
sidebar <- dashboardSidebar(
  
  # sidebarMenu ----
  sidebarMenu(
    
    menuItem(text = "About", tabName = "about", icon = icon("house")),
    menuItem(text = "Vulnerabilty Maps", tabName = "dashboard", icon = icon("leaf")),
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
            
            # left-hand column ----
            fluidRow(width = 12,
                   
                   # background box ----
                   box(width = 12,
                       
                       includeMarkdown("text/background.md")
                       # tags$img(src = "FishCreekWatershedSiteMap_2020.jpeg", 
                       #          alt = "A map of Northern Alaska, showing Fish Creek Watershed located within the National Petroleum Reserve.",
                       #          style = "max-width: 100%;"),
                       # tags$h6(tags$em("Map Source:", tags$a(href = "http://www.fishcreekwatershed.org/", "FCWO")),
                       #         style = "text-align: center;")
                       
                   ) # END background box
                   
            ),# END left-hand column
            
            # fluidRow
            fluidRow(
              box(width = 6,
                  title = tagList(icon("tree"), strong("Our Approach")),
                  includeMarkdown("text/approach.md")
              ),
              box(width = 6,
                  title = tagList(icon("tree"), strong("Data Sources")),
                  includeMarkdown("text/data.md")
                  
                  )
              
              
            ) # end of fluidRow
            
    ), # END about tabItem 
    
    # dashboard tabItem ----
    tabItem(tabName = "dashboard",
            
            # fluidRow ----
            fluidRow(
              
              # input box ----
              box(width = 8,
                  title = tagList(icon("tree"), strong("Mapping Tree Vulnerabilty")),
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
                              choices = c("Scientific Name"="",unique(combined_pred$spp)),
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
                  # CATGEGORICAL VERSUS CONTINUOUS VALUES 
                  # verticalLayout(
                  #   radioGroupButtons(inputId = "map_type_button", 
                  #                label = "Choose map type:",
                  #                choices = names(combined_pred_raster))
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
                      
                      title = tags$strong("Tree Species Sensitivity to CWD"),
                      
                      # interactive map output ----
                      leafletOutput(outputId = "map_output")
                      
                      
                      
                  ), # END leaflet box
              
              
            #), # END fluidRow
            tags$style(".small-box.bg-aqua { background-color: #A3b97b !important; color: #295a56 !important; }"),
            # tags$style(".small-box.bg-purple { background-color: #B03B12 !important; color: #FFFFFF !important; }"),
            # tags$style(".small-box.bg-blue { background-color: #FFFF00 !important; color: #FFFFFF !important; }"),
              
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
              box(width = 6,
                  
                  title = tagList(icon("floppy-disk"), strong("Data")),
                  
                  # start select Input
                  pickerInput(inputId = "sp_code_data_input",
                              label = "Select one or more species of interest by code, \n then click download:",
                              choices = unique(combined_pred$sp_code),
                              selected = NULL,
                              multiple = TRUE,
                              width = "60%",
                              inline = FALSE,
                              options = list(`actions-box` = TRUE, subtext = "subtext")),
                  
              ),# END input species box 
              box(width = 6,
                  # Button
                  "Click here to Download Data",br(),
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