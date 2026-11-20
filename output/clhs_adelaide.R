library(terra)  # install.packages(c("terra", "clhs"))
library(clhs)
set.seed(2027)
options(scipen = 999)   # keine 3e+05 auf den Achsen

# Arbeitsverzeichnis = Ordner dieses Skripts
# (RStudio: Session > Set Working Directory > To Source File Location)
# Die Rasterdaten liegen im Unterordner data/ (nicht im Repository, siehe README)
awc   <- rast("data/AWC_005_015_EV_N_P_AU_TRN_N_20210614.tif")  # TERN, 5-15 cm
rain  <- rast("data/rain_mean_2015_2024.tif")                    # aus rainfallr.R
slope <- rast("data/slope_adelaide.tif")                         # TERN SLGA, 1 arc-second
soil  <- vect("data/soil_order.shp")                             # Atlas of Australian Soils
dir.create("output", showWarnings = FALSE)

# Gebiet um Adelaide, alles auf ein 250 m Raster (GDA2020 / MGA 54)
gebiet <- ext(138.4, 139.3, -35.5, -34.5)
awc   <- project(crop(awc, gebiet), "EPSG:7854", res = 250)
rain  <- project(rain, awc)
slope <- project(crop(slope, gebiet), awc, method = "average")  # 30 m -> 250 m gemittelt
soil  <- rasterize(project(soil, "EPSG:7854"), awc, field = "Dom_Order")
covs  <- c(soil, awc, rain, slope)
names(covs) <- c("soil", "awc", "rain", "slope")

d <- as.data.frame(covs, xy = TRUE, na.rm = TRUE)
d$soil <- factor(d$soil)
nrow(d)
table(d$soil)

vars <- c("soil", "awc", "rain", "slope")

# cLHS mit 15 und 40 Punkten
p15 <- clhs(d[, vars], size = 15, iter = 50000, simple = TRUE)
p40 <- clhs(d[, vars], size = 40, iter = 50000, simple = TRUE)

# Abdeckung: Anteil der 10 Dezile (Zahlen) bzw. der Bodenordnungen, die mind. einen Punkt haben
abdeckung <- function(i) {
  zahlen <- sapply(c("awc", "rain", "slope"), function(v) {
    q <- unique(quantile(d[[v]], seq(0, 1, 0.1)))
    mean(table(cut(d[[v]][i], q, include.lowest = TRUE)) > 0)
  })
  c(soil = length(unique(d$soil[i])) / nlevels(d$soil), zahlen)
}
zufall <- function(n) rowMeans(replicate(1000, abdeckung(sample(nrow(d), n))))

res <- round(100 * rbind(clhs_15 = abdeckung(p15), zufall_15 = zufall(15),
                         clhs_40 = abdeckung(p40), zufall_40 = zufall(40)))
res
write.csv(res, "output/abdeckung.csv")
write.csv(d[p15, ], "output/clhs_15_punkte.csv", row.names = FALSE)
write.csv(d[p40, ], "output/clhs_40_punkte.csv", row.names = FALSE)

# Zum Vergleich: erwartete Abdeckung bei Zufall, wenn jedes Dezil 10 % der Fläche hat
round(100 * (1 - 0.9^c(15, 40)), 1)   # 79.4 und 98.5

# Robustheit der Bodenordnung: cLHS mit anderen Seeds
for (s in 1:3) {
  set.seed(s)
  for (n in c(15, 40)) {
    p <- clhs(d[, vars], size = n, iter = 50000, simple = TRUE)
    cat("Seed", s, "-", n, "Punkte:", nlevels(droplevels(d$soil[p])), "von", nlevels(d$soil), "Bodenordnungen\n")
  }
}
set.seed(2027)

# Farben wie in der Konzeptkarte
regen_farben <- hcl.colors(50, "PuRd", rev = TRUE)

# Karte: cLHS vs. Zufall, je 15 Punkte
z15 <- sample(nrow(d), 15)
png("output/clhs_vs_zufall_15.png", width = 2400, height = 1300, res = 200)
par(mfrow = c(1, 2))
plot(covs$rain, col = regen_farben, main = "cLHS, 15 points (rainfall, mm/yr)")
points(d$x[p15], d$y[p15], pch = 21, bg = "black", col = "white", cex = 1.3)
plot(covs$rain, col = regen_farben, main = "Random, 15 points (rainfall, mm/yr)")
points(d$x[z15], d$y[z15], pch = 21, bg = "white", col = "black", cex = 1.3)
dev.off()

# Wo liegen die Punkte im Merkmalsraum?
png("output/merkmalsraum_15.png", width = 1600, height = 1400, res = 200)
plot(d$rain, d$awc, pch = 16, cex = 0.3, col = "grey80",
     xlab = "Mean annual rainfall 2015-2024 (mm)", ylab = "AWC 5-15 cm (%)")
points(d$rain[z15], d$awc[z15], pch = 24, bg = "white")
points(d$rain[p15], d$awc[p15], pch = 21, bg = "black", col = "white", cex = 1.2)
legend("topright", c("all cells", "cLHS (15)", "random (15)"), pch = c(16, 21, 24),
       col = c("grey80", "white", "black"), pt.bg = c(NA, "black", "white"))
dev.off()
