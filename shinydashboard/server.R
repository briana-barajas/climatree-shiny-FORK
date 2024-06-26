server <- function(input, output) {
  
  
  ## ======================================================
  ##                  About page table                 ----
  ## ====================================================== 
  # Render the data table with a search bar
  output$speciesTable <- renderDataTable({
    meta_df}, 
    
    options = list(
      searching = TRUE,
      lengthChange = FALSE,
      pageLength = 10))
  
  ## ======================================================
  ##                   Map by Species Code             ----
  ## ======================================================  
  observeEvent(input$sp_code_input, {
    
    output$map_output <- renderLeaflet({
      validate(need(input$sp_code_input, 'Select a species to begin'))
      
      # select raster
      rast <- code_rast_list[[input$sp_code_input]]
      
      if(input$sp_code_input %in% all_neg_code){
        leaflet() %>% 
          addTiles() %>% 
          addStarsImage(rast, colors = c("#B03B12", "#EC9971", "#F9E0D2"),
                        opacity = input$map_transparency_input) %>% 
          addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2"),
                    labels = c("High", "Moderate", "Low"),
                    values = values(rast),
                    title = "Drought Sensitivity")
      } else {
        leaflet() %>% 
          addTiles() %>% 
          addStarsImage(rast, colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                        opacity = input$map_transparency_input) %>% 
          addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                    labels = c("High", "Moderate", "Low", "Least Concern"),
                    values = values(rast),
                    title = "Drought Sensitivity")
      }
      
    }) # END sp_code render Leaflet
    
  }) # END sp_code observeEvent
  
  
  ## ======================================================
  ##                  Map by Scientific Name           ----
  ## ====================================================== 
  observeEvent(input$sci_name_input, {
    
    output$map_output <- renderLeaflet({
      
      validate(need(input$sci_name_input, 'Select a species to begin'))
      
      # clean input 
      cleaned_input <- gsub(" ", "_", input$sci_name_input)
      
      # select raster
      rast <- sci_name_rast_list[[cleaned_input]]
      
      if(input$sci_name_input %in% all_neg_sci_name){
        leaflet() %>% 
          addTiles() %>% 
          addStarsImage(rast, colors = c("#B03B12", "#EC9971", "#F9E0D2"),
                        opacity = input$map_transparency_input) %>% 
          addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2"),
                    labels = c("High", "Moderate", "Low"),
                    values = values(rast),
                    title = "Drought Sensitivity")
      } else {
        leaflet() %>% 
          addTiles() %>% 
          addStarsImage(rast, colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                        opacity = input$map_transparency_input) %>% 
          addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                    labels = c("High", "Moderate", "Low", "Least Concern"),
                    values = values(rast),
                    title = "Drought Sensitivity")
      }
      
    }) # END scientific_name render Leaflet
    
  }) # END scientific_name observeEvent
  
  
  
  ## ======================================================
  ##                  Map by Common Name               ----
  ## ====================================================== 
  observeEvent(input$common_name_input, {
    
    output$map_output <- renderLeaflet({
      
      validate(need(input$common_name_input, 'Select a species to begin'))
      
      # clean input 
      cleaned_input <- gsub(" ", "_", input$common_name_input)
      
      # select raster
      rast <- common_name_rast_list[[cleaned_input]]
      
      if(input$common_name_input %in% all_neg_common_name){
        leaflet() %>% 
          addTiles() %>% 
          addStarsImage(rast, colors = c("#B03B12", "#EC9971", "#F9E0D2"),
                        opacity = input$map_transparency_input) %>% 
          addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2"),
                    labels = c("High", "Moderate", "Low"),
                    values = values(rast),
                    title = "Drought Sensitivity")
      } else {
        leaflet() %>% 
          addTiles() %>% 
          addStarsImage(rast, colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                        opacity = input$map_transparency_input) %>% 
          addLegend(colors = c("#B03B12", "#EC9971", "#F9E0D2", "#144D6F"),
                    labels = c("High", "Moderate", "Low", "Least Concern"),
                    values = values(rast),
                    title = "Drought Sensitivity")
      }
      
    }) # END common_name render Leaflet
    
  }) # END common_name observeEvent
  
  
  ## ======================================================
  ##                  Dataset Download               ----
  ## ======================================================
  observeEvent(input$download_common_name_input, {
    
    output$reactive_download_table_output <- renderDataTable({
      
      validate(need(input$download_common_name_input, 'Select a species to begin'))
      
      combined_pred %>% 
        filter(common_name %in% input$download_common_name_input)
    })})
  
  observeEvent(input$download_sci_name_input, {
    
    output$reactive_download_table_output <- renderDataTable({
      
      validate(need(input$download_sci_name_input, 'Select a species to begin'))
      
      combined_pred %>% 
        filter(scientific_name %in% input$download_sci_name_input)
    })})
  
  observeEvent(input$download_sp_code_input, {
    
    output$reactive_download_table_output <- renderDataTable({
      
      validate(need(input$download_sci_name_input, 'Select a species to begin'))
      
      combined_pred %>% 
        filter(sp_code %in% input$download_sp_code_input)
    })})
  
  
  
  
  
} # END SERVER