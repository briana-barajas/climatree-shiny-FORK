# ==== LOAD LIBRARIES ====

# ==== essential libraries ====
library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinycssloaders)
library(leaflet)
library(markdown)
library(terra)
library(raster)
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
sass(
  input = sass_file("www/sass-styles.scss"),
  output = "www/sass-styles.css",
  options = sass_options(output_style = "compressed") # OPTIONAL, but speeds up page load time by removing white-space & line-breaks that make css files more human-readable
)


# ==== READ IN DATA ====

# meta_df
meta_df <- read_csv("~/../../capstone/climatree/input/external/species_metadata.csv") %>% 
  rename(sp_code = species_id) %>% 
  dplyr::select(sp_code, spp, common_name)

#combined_raster
combined_pred <- read_csv("~/../../capstone/climatree/output/final-output/combined_predictions.csv") %>% 
  rename(sp_code = species_code) %>% 
  left_join(meta_df, join_by(sp_code))


# .........................create sp_code raster list......................
code_rast_list <- list()

for (i in unique(combined_pred$sp_code)) {
  
  # filter to a single species
  single_spp <- combined_pred %>% 
    filter(sp_code == i) %>%
    dplyr::select(x, y, cwd_sens) %>%
    as.data.frame()
  
  # create raster
  rast <- tidyterra::as_spatraster(single_spp, crs = "+proj=longlat +datum=WGS84")
  rast <- raster(rast)
  
  # add raster to list
  code_rast_list[[as.character(i)]] <- rast
}

# .........................create sci_name raster list......................
sci_name_rast_list <- list()

for (i in unique(combined_pred$spp)) {
  
  # filter to a single species
  single_spp <- combined_pred %>%
    filter(spp == i) %>%
    dplyr::select(x, y, cwd_sens) %>%
    as.data.frame()
  
  # create raster
  rast <- tidyterra::as_spatraster(single_spp, crs = "+proj=longlat +datum=WGS84")
  rast <- raster(rast)
  
  # rename without spaces
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
    dplyr::select(x, y, cwd_sens) %>%
    as.data.frame()
  
  # create raster
  rast <- tidyterra::as_spatraster(single_spp, crs = "+proj=longlat +datum=WGS84")
  rast <- raster(rast)
  
  # rename without spaces
  clean_name <- gsub(" ", "_", i)
  
  # add raster to list
  common_name_rast_list[[clean_name]] <- rast
}


# ==== PALETTES ====
palette <- c("#FEFFD9FF", "#FDFFD7FF", "#FDFED6FF", "#FCFED4FF", "#FBFED3FF", "#FAFDD1FF", "#FAFDD0FF", "#F9FDCEFF", "#F8FDCCFF", "#F8FCCBFF", "#F7FCC9FF", "#F6FCC8FF", "#F5FBC6FF", "#F5FBC5FF", "#F4FBC3FF", "#F3FAC1FF", "#F2FAC0FF", "#F1FABFFF", "#F0F9BEFF", "#EFF9BDFF", "#EEF9BCFF", "#EDF8BBFF", "#ECF8BBFF", "#EBF7BAFF", "#E9F7B9FF", "#E8F6B8FF", "#E7F6B8FF", "#E6F6B7FF", "#E5F5B6FF", "#E4F5B5FF", "#E2F4B4FF", "#E1F4B4FF", "#E0F3B3FF", "#DFF3B2FF", "#DDF2B2FF", "#DCF2B2FF", "#DAF1B2FF", "#D9F1B2FF", "#D7F0B2FF", "#D5F0B2FF", "#D4EFB2FF", "#D2EFB2FF", "#D0EEB1FF", "#CFEEB1FF", "#CDEDB1FF", "#CBECB1FF", "#CAECB1FF", "#C8EBB1FF", "#C6EBB1FF", "#C5EAB1FF", "#C3E9B1FF", "#C0E8B2FF", "#BDE7B2FF", "#BAE6B2FF", "#B8E5B3FF", "#B5E3B3FF", "#B2E2B3FF", "#AFE1B4FF", "#ACE0B4FF", "#A9DEB5FF", "#A6DDB5FF", "#A3DCB5FF", "#A0DBB6FF", "#9DDAB6FF", "#9AD8B6FF", "#97D7B7FF", "#94D6B7FF", "#92D5B7FF", "#8FD4B8FF", "#8DD3B8FF", "#8AD2B9FF", "#88D1B9FF", "#86D0BAFF", "#83CFBAFF", "#81CEBAFF", "#7ECDBBFF", "#7BCCBBFF", "#79CBBCFF", "#76CABCFF", "#73C9BDFF", "#70C8BDFF", "#6DC7BDFF", "#6AC6BEFF", "#68C5BEFF", "#66C4BFFF", "#64C3BFFF", "#62C2BFFF", "#60C1C0FF", "#5DC0C0FF", "#5BBFC0FF", "#59BFC1FF", "#57BEC1FF", "#54BDC1FF", "#52BCC2FF", "#4FBBC2FF", "#4DBAC3FF", "#4ABAC3FF", "#47B9C3FF", "#44B8C4FF", "#41B7C4FF")

palette_orange_blue <- c("#9E3D22FF", "#A13F22FF", "#A44122FF", "#A84222FF", "#AB4422FF", "#AE4622FF", "#B14822FF", "#B54A22FF", "#B84B22FF", "#BB4D22FF", "#BE4F22FF", "#C25122FF", "#C55322FF", "#C85422FF", "#CC5621FF", "#CF5821FF", "#D25A21FF", "#D55D22FF", "#D76023FF", "#D96324FF", "#DB6725FF", "#DD6A26FF", "#DF6D27FF", "#E27029FF", "#E4732AFF", "#E6772BFF", "#E87A2CFF", "#EA7D2EFF", "#EC802FFF", "#EE8330FF", "#F08731FF", "#F28A32FF", "#F48D34FF", "#F69035FF", "#F6943FFF", "#F59949FF", "#F59D52FF", "#F4A15BFF", "#F3A564FF", "#F2A96DFF", "#F0AE76FF", "#EFB27EFF", "#EDB687FF", "#EBBA90FF", "#E9BE99FF", "#E7C2A1FF", "#E4C7AAFF", "#E2CBB3FF", "#DECFBCFF", "#DBD3C5FF", "#D6D4C9FF", "#D1D1CAFF", "#CCCFCBFF", "#C6CCCBFF", "#C1CACCFF", "#BBC7CDFF", "#B6C5CDFF", "#B0C2CEFF", "#AAC0CEFF", "#A5BDCFFF", "#9FBBD0FF", "#98B8D0FF", "#92B6D1FF", "#8CB3D1FF", "#85B1D2FF", "#7EAED2FF", "#77ACD3FF", "#75A9D1FF", "#72A7CFFF", "#70A4CCFF", "#6DA1CAFF", "#6B9FC8FF", "#699CC6FF", "#6699C4FF", "#6497C1FF", "#6194BFFF", "#5F92BDFF", "#5C8FBBFF", "#5A8CB9FF", "#588AB7FF", "#5587B4FF", "#5385B2FF", "#5082B0FF", "#4E80AEFF", "#4C7EACFF", "#4A7BA9FF", "#4879A7FF", "#4577A5FF", "#4374A3FF", "#4172A0FF", "#3F709EFF", "#3D6E9CFF", "#3B6B9AFF", "#386997FF", "#366795FF", "#346593FF", "#326391FF", "#30608EFF", "#2D5E8CFF", "#2B5C8AFF")
