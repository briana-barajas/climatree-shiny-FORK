# ==== essential libraries ====
library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinycssloaders)
library(leaflet)
library(markdown)
library(terra)
library(stars)
library(leafem)
library(tidyterra)

library(shinyWidgets)

library(DT)
library(leaflet.extras)
library(googleway)
library(htmlwidgets)
library(htmltools)
library(fontawesome)
library(fresh)
library(sass)
library(tidyterra)

# ==== COMPILE CSS ==== 
# sass(
#   input = sass_file("www/sass-styles.scss"),
#   output = "www/sass-styles.css",
#   options = sass_options(output_style = "compressed") # OPTIONAL, but speeds up page load time by removing white-space & line-breaks that make css files more human-readable
# )


# ==== READ IN DATA ====

# meta_df
meta_df <- read_csv("~/../../capstone/climatree/output/repo-and-slides/species_metadata.csv")

# species sens for download (easy to understand col names)
combined_pred_raw <- read_csv("~/../../capstone/climatree/output/repo-and-slides/combined_predictions_slides.csv")

# .........................create sens level bins.........................
# create a df with custom sens levels, grouped by each species
combined_pred <- data.frame()

for (i in unique(combined_pred_raw$sp_code)) {
  
  single_spp <- combined_pred_raw %>%
    filter(sp_code == i) %>%
    as.data.frame()
  
  quant <- quantile(single_spp$drought_sens[single_spp$drought_sens < 0], probs = c(0.25,0.75))
  
  single_spp <- single_spp %>% 
    mutate(sens_level = case_when(
      drought_sens >= 0 ~ "Least Concern",
      drought_sens <= quant[1] ~ "High Sensitivity",
      drought_sens > quant[1] & drought_sens <= quant[2] ~ "Moderate Sensitivity",
      drought_sens > quant[2] & drought_sens < 0 ~ "Low Sensitivity")) %>% 
    mutate(sens_level = factor(sens_level,
                               levels = c("High Sensitivity", "Moderate Sensitivity", 
                                          "Low Sensitivity", "Least Concern"), ordered = TRUE)) %>% 
    left_join(meta_df, join_by(sp_code)) %>% 
    select(all_of(c("longitude", "latitude", "drought_sens", 
                    "sens_level", "sp_code", "scientific_name", "common_name")))
  
  combined_pred <- rbind(combined_pred, single_spp)
  
}

rm(combined_pred_raw)

#....................... list species with only negative values.....................
all_neg <- combined_pred %>% group_by(sp_code) %>% filter(all(drought_sens < 0))
all_neg_code <- unique(all_neg$sp_code)
all_neg_sci_name <- unique(all_neg$scientific_name)
all_neg_common_name <- unique(all_neg$common_name)


# .........................create sp_code raster list......................
code_rast_list <- list()

for (i in unique(combined_pred$sp_code)) {
  
  # filter to single species
  single_spp <- combined_pred %>% 
    filter(sp_code == i) %>% 
    select(longitude, latitude, sens_level)
  
  # create raster
  rast <- tidyterra::as_spatraster(single_spp, crs = "+proj=longlat +datum=WGS84")
  rast <- st_as_stars(rast)
  
  # add raster to list
  code_rast_list[[as.character(i)]] <- rast
}

# .........................create sci_name raster list......................
sci_name_rast_list <- list()

for (i in unique(combined_pred$scientific_name)) {
  
  # filter to a single species
  single_spp <- combined_pred %>% 
    filter(scientific_name == i) %>%
    dplyr::select(longitude, latitude, sens_level) %>%
    as.data.frame()
  
  # create raster
  rast <- tidyterra::as_spatraster(single_spp, crs = "+proj=longlat +datum=WGS84")
  rast <- st_as_stars(rast)
  
  # remove spaces from name
  clean_name <- gsub(" ", "_", i)
  
  # add raster to list
  sci_name_rast_list[[clean_name]] <- rast
}

# .........................create common_name raster list......................
common_name_rast_list <- list()

for (i in unique(combined_pred$common_name)) {
  
  # filter to a single species
  single_spp <- combined_pred %>% 
    filter(common_name == i) %>%
    dplyr::select(longitude, latitude, sens_level) %>%
    as.data.frame()
  
  # create raster
  rast <- tidyterra::as_spatraster(single_spp, crs = "+proj=longlat +datum=WGS84")
  rast <- st_as_stars(rast)
  
  # remove spaces from name
  clean_name <- gsub(" ", "_", i)
  
  # add raster to list
  common_name_rast_list[[clean_name]] <- rast
}