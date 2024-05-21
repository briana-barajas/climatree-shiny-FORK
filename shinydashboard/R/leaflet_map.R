leaflet_map <- function(input) {
  
  combined_pred_reactive <- reactive({
    combined_pred %>%
      filter(species_code == input$species_code_input) 
    })
    
  
  
      
  # do we need to filter
  renderLeaflet({
    # 
    # observeEvent(input$map_type_button, {
    #   combined_pred_raster() <- switch(input$map_type_button,
    #                                    "rwi_pred_change_mean" = rwi_pred_change_mean,
    #                                    "cwd_sens" = cwd_sens)}
    
    
      test_map <- leaflet() %>%
        addProviderTiles(providers$Esri.WorldStreetMap)%>%

        # Add two tiles
        # --- set View to ext of data 
        
        # set view over Santa Barbara
        setView(-71.0382679, 42.3489054, zoom = 10) %>% 
        # add minimap 
        addMiniMap(toggleDisplay = TRUE) %>% 
        
        # --- add raster image
        # i think this is the problem 
        addPolygons(data = combined_pred)
      
      
      return(test_map)
    }) # END renderLeaflet
}
  



# SAMS CODE BELOW

