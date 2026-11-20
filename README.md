# adelaide-sampling-map

I sampled 15 plots for my bachelor’s thesis and still don’t know if that was enough. I’m going to CSIRO in Adelaide in 2027, so I made a map of soil order, water capacity, rainfall and slope there. When I tried to place sampling points I just picked them by eye. Then I read Xia et al. 2024 (Geoderma), who used conditioned Latin hypercube sampling (cLHS), and tried the method on my map. This is only a small test of the sampling idea.

15 cLHS points hit every decile of rainfall, water capacity and slope, 15 random points about 79 %. With 40 points both cover these well. Rare soil types were missed either way. Nothing was actually sampled, I’m just testing which method could fit best.

The data is not included because it is too big for GitHub. To run the scripts, download it from the sources below and put it in a folder called data next to the scripts. R packages: terra, clhs.

Dumler_sampling_concept_map.pdf
clhs_adelaide.R 
rainfallr.R - rainfall 2015-2024 from SILO
slope.R - slope from TERN (needs an API key)
png/csv - results and point coordinates

Data: TERN Soil and Landscape Grid AWC 5-15 cm (doi:10.25919/4jwj-na34), TERN slope 1 arc-second (doi:10.25919/jr32-yq58), SILO rainfall, Atlas of Australian Soils (CSIRO)
