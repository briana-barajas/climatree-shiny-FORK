server <- function(input, output) {
  
  
  # === LEAFLET MAPPING ===
  
  ## ======================================================
  ##                   Map by Species Code             ----
  ## ======================================================  
  observeEvent(input$sp_code_input,
               output$map_output <- renderLeaflet({
                 
                 # select raster
                 single_spp <- code_rast_list[[input$sp_code_input]]
                 
                 # create palette
                 pal <- colorQuantile(c("#E56C3A", "#F9E0D2", "#72BFE6","#144D6F"),
                                      single_spp$cwd_sens,
                                      n = 4,
                                      na.color = "transparent")
                 
                 # plot
                 leaflet() %>% addTiles() %>%
                   addRasterImage(single_spp, colors = pal, opacity = 0.8) %>%
                   addLegend(colors = c("#E56C3A", "#F9E0D2", "#72BFE6","#144D6F"),
                             labels = c("Highly Sensitive", "Moderately Sensitive", "Not Sensitive", "Least Concern"),
                             values = values(single_spp),
                             title = "Relative Sensitivity")
                 
               }) # END sp_code render Leaflet
               
  ) # END sp_code observeEvent
  
  
  ## ======================================================
  ##                  Map by Scientific Name           ----
  ## ====================================================== 
  observeEvent(input$sci_name_input,
               output$map_output <- renderLeaflet({
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sci_name_input)
                 
                 # select raster
                 single_spp <- sci_name_rast_list[[cleaned_input]]
                 
                 # create palette
                 pal <- colorQuantile(c("#E56C3A", "#F9E0D2", "#72BFE6","#144D6F"),
                                      single_spp$cwd_sens,
                                      n = 4,
                                      na.color = "transparent")
                 
                 # plot
                 leaflet() %>% addTiles() %>%
                   addRasterImage(single_spp, colors = pal, opacity = 0.8) %>%
                   addLegend(colors = c("#E56C3A", "#F9E0D2", "#72BFE6","#144D6F"),
                             labels = c("Highly Sensitive", "Moderately Sensitive", "Not Sensitive", "Least Concern"),
                             values = values(single_spp),
                             title = "Relative Sensitivity")
                 
               }) # END sci_name render Leaflet
               
  ) # END sci_name observeEvent
  
  
  ## ======================================================
  ##                  Map by Common Name               ----
  ## ====================================================== 
  observeEvent(input$common_name_input,
               output$map_output <- renderLeaflet({
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$common_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 # create palette
                 pal <- colorQuantile(c("#E56C3A", "#F9E0D2", "#72BFE6","#144D6F"),
                                      single_spp$cwd_sens,
                                      n = 4,
                                      na.color = "transparent")
                 
                 # plot
                 leaflet() %>% addTiles() %>%
                   addRasterImage(single_spp, colors = pal, opacity = 0.8) %>%
                   addLegend(colors = c("#E56C3A", "#F9E0D2", "#72BFE6","#144D6F"),
                             labels = c("Highly Sensitive", "Moderately Sensitive", "Not Sensitive", "Least Concern"),
                             values = values(single_spp),
                             title = "Relative Sensitivity")
                 
               }) # END common_name render Leaflet
               
  ) # END common_name observeEvent



# === DATASET DOWNLOAD ===

# Reactive value for selected dataset ----
datasetInput <- reactive({
    combined_pred %>% 
    filter(sp_code %in% c(input$sp_code_data_input))
})

# Table of selected dataset ----
output$table <- renderTable({
  datasetInput()
})

# Downloadable csv of selected dataset ----
output$downloadData <- downloadHandler(
  filename = function() {
    paste(input$sp_code_data_input, "_cwd_sens.csv", sep = "")
  },
  content = function(file) {
    write.csv(datasetInput(), file, row.names = FALSE)
  }
)

# === RENDER DATATABLE ===

output$data_table_output <- DT::renderDataTable({
  DT::datatable(datasetInput() ,options = list(pageLength = 10, scrollX = TRUE),
                rownames = FALSE
  )
})

}