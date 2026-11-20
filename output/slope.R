Sys.setenv("GDAL_HTTP_HEADER_FILE" = "C:/Users/alisc/OneDrive/Documents/CSIROxCOLUMBIA/TERNAPIKey.txt")
library(terra)
slope <- rast("/vsicurl/https://data.tern.org.au/model-derived/slga/NationalMaps/Covariates/Mosaics/30m/Relief_slopedeg_1s.tif")
slope <- crop(slope, ext(137.5, 140.0, -36.0, -34.0))
plot(slope)
writeRaster(slope, "C:/temp/slope_adelaide.tif", overwrite = TRUE)

file.exists("C:/temp/slope_adelaide.tif")
plot(slope)