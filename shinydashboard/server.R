server <- function(input, output) {
  
  
  # === LEAFLET MAPPING ===
  
  ## ======================================================
  ##                   Map by Species Code             ----
  ## ======================================================  
  observeEvent(input$sp_code_input, {
               
               output$map_output <- renderLeaflet({
                 validate(need(input$sp_code_input, 'Select a species to begin'))
                 
                 # select raster
                 single_spp <- code_rast_list[[input$sp_code_input]]
                 
                 # create palette
                 pal <- colorQuantile(c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                                      single_spp$cwd_sens,
                                      n = 4,
                                      na.color = "transparent")
                 
                 # plot
                 leaflet() %>% addTiles() %>%
                   addRasterImage(single_spp, colors = pal, opacity = input$map_transparency_input) %>%
                   addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                             labels = c("High Sensitivity", "Moderate Sensitivity", "Low Sensitivity", "Least Concern"),
                             values = values(single_spp),
                             title = "Relative Sensitivity")
                 
               }) # END sp_code render Leaflet
               output$max_sens_box <- renderValueBox({
                 validate(need(input$sp_code_input, 'Select a species to begin'))
                 
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sp_code_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(maxValue(single_spp$cwd_sens), digits = 2), subtitle = "Max Sensitivty", icon = icon("tree")
                 )
               })
               
               output$min_sens_box <- renderValueBox({
                 
                 validate(need(input$sp_code_input, ''))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sp_code_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(minValue(single_spp$cwd_sens), digits = 2), subtitle = "Min Sensitivty", icon = icon("tree")
                 )
               })
               
               output$mean_sens_box <- renderValueBox({
                 validate(need(input$sp_code_input, ''))
                 
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sp_code_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(cellStats(single_spp$cwd_sens, stat = 'mean'), digits = 2), subtitle = "Average Sensitivty", icon = icon("tree")
                 )
               })
               }# END sp_code observeEvent
  )
  
  
  ## ======================================================
  ##                  Map by Scientific Name           ----
  ## ====================================================== 
  observeEvent(input$sci_name_input,{
               output$map_output <- renderLeaflet({
                 validate(need(input$sci_name_input, 'Select a species to begin'))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sci_name_input)
                 
                 # select raster
                 single_spp <- sci_name_rast_list[[cleaned_input]]
                 
                 # create palette
                 pal <- colorQuantile(c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                                      single_spp$cwd_sens,
                                      n = 4,
                                      na.color = "transparent")
                 
                 # plot
                 leaflet() %>% addTiles() %>%
                   addRasterImage(single_spp, colors = pal, opacity = input$map_transparency_input) %>%
                   addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                             labels = c("High Sensitivity", "Moderate Sensitivity", "Low Sensitivity", "Least Concern"),
                             values = values(single_spp),
                             title = "Relative Sensitivity")
                 
               }) # END sci_name render Leaflet
               
               output$max_sens_box <- renderValueBox({
                 validate(need(input$sci_name_input, 'Select a species to begin'))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sci_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(maxValue(single_spp$cwd_sens), digits = 2), subtitle = "Max Sensitivty", icon = icon("tree")
                          )
               })
               
               
               output$min_sens_box <- renderValueBox({
                 validate(need(input$sci_name_input, 'Select a species to begin'))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sci_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(minValue(single_spp$cwd_sens), digits = 2), subtitle = "Min Sensitivty", icon = icon("tree")
                 )
               })
               
               output$mean_sens_box <- renderValueBox({
                 validate(need(input$sci_name_input, 'Select a species to begin'))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$sci_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(cellStats(single_spp$cwd_sens, stat = 'mean'), digits = 2), subtitle = "Average Sensitivty", icon = icon("tree")
                 )
               })
               
               }
               
  ) # END sci_name observeEvent
  
  
  ## ======================================================
  ##                  Map by Common Name               ----
  ## ====================================================== 
  
  
  observeEvent(input$common_name_input, {
 
               output$map_output <- renderLeaflet({
                 validate(need(input$common_name_input, 'Select a species to begin'))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$common_name_input)

                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 # create palette
                 pal <- colorQuantile(c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                                      single_spp$cwd_sens,
                                      n = 4,
                                      na.color = "transparent")
                 
                 # plot
                 leaflet() %>% addTiles() %>%
                   addRasterImage(single_spp, colors = pal, opacity = input$map_transparency_input) %>%
                   addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                             labels = c("High Sensitivity", "Moderate Sensitivity", "Low Sensitivity", "Least Concern"),
                             values = values(single_spp),
                             title = "Relative Sensitivity")
                 
               }) # END common_name render Leaflet
               output$max_sens_box <- renderValueBox({
                 validate(need(input$common_name_input, 'Select a species to begin'))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$common_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(maxValue(single_spp$cwd_sens), digits = 2), subtitle = "Max Sensitivty", icon = icon("tree")
                 )
               })
               
               output$min_sens_box <- renderValueBox({
                 
                 validate(need(input$common_name_input, ''))
                 
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$common_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(minValue(single_spp$cwd_sens), digits = 2), subtitle = "Min Sensitivty", icon = icon("tree")
                 )
               })
               
               output$mean_sens_box <- renderValueBox({
                 
                 validate(need(input$common_name_input, ''))
                 # clean input name
                 cleaned_input <- gsub(" ", "_", input$common_name_input)
                 
                 # select raster
                 single_spp <- common_name_rast_list[[cleaned_input]]
                 
                 valueBox(value = round(cellStats(single_spp$cwd_sens, stat = 'mean'), digits = 2), subtitle = "Average Sensitivty", icon = icon("tree")
                 )
               })
               

  }
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