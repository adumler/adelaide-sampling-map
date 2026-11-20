library(terra)
dir.create("C:/temp", showWarnings = FALSE)
years <- 2015:2024
yearly <- lapply(years, function(y) {
  f <- paste0("C:/temp/", y, ".monthly_rain.nc")
  if (!file.exists(f)) download.file(
    paste0("https://s3-ap-southeast-2.amazonaws.com/silo-open-data/Official/annual/monthly_rain/", y, ".monthly_rain.nc"),
    f, mode = "wb")
  sum(rast(f))              # Jahressumme aus 12 Monaten
})
rain <- mean(rast(yearly))  # Mittel über die Jahre
if (crs(rain) == "") crs(rain) <- "EPSG:4326"
rc <- crop(rain, ext(137.5, 140.0, -36.0, -34.0))
plot(rc)
writeRaster(rc, "C:/temp/rain_mean_2015_2024.tif", overwrite = TRUE)