# adelaide-sampling-map

I sampled 15 plots for my bachelor's thesis and still don't know if that was
enough. I'm going to CSIRO in Adelaide in 2027, so I made a map of soil order,
water capacity, rainfall and slope there. When I tried to place sampling points
I just picked them by eye. Then I read Xia et al. 2024 (Geoderma) and tried
their method, cLHS, against random points.

15 cLHS points covered the whole range of rainfall, water capacity and slope,
15 random points about 79 %. With 40 points both are fine. Rare soil types were
missed either way. Nothing was actually sampled, im just testing which method could fit the best.

The data are too big for GitHub, put them in a folder called
data next to the script. R packages: terra, clhs.

Dumler_sampling_concept_map.pdf - the map
clhs_adelaide.R - cLHS vs random
rainfallr.R - rainfall 2015-2024 from SILO
slope.R - slope from TERN (needs an API key)
png/csv - results and
