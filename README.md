I sampled 15 plots for my bachelor thesis and still don’t know if that was enough. I’m going to CSIRO in Adelaide in 2027, so I made a map of soil order, water capacity, rainfall and slope there. When I tried to place sampling points I just picked them by looking at the map. Then I read Xia et al. 2024 (Geoderma) and tried their way of choosing sampling points on my map, conditioned Latin hypercube sampling (cLHS, Minasny & McBratney 2006).

15 cLHS points hit every decile of rainfall, water capacity and slope, 15 random points about 79 %. With 40 points both cover these well. Most points landed on the common soils (Chromosols, Calcarosols, Kurosols). Rare ones like Podosols and Hydrosols (under 0.5 % of the area) got no cLHS point, and random points only hit them rarely. Nothing was actually sampled yet, I’m just testing which method could fit the best.

The data is not included because it is too big for GitHub. To run the scripts, download it from the sources below and put it in a folder called data next to the scripts. Results go to output. R packages: terra, clhs. For slope.R you need your own TERN API key in a file called TERNAPIKey.txt.

output/Dumler_sampling_concept_map.pdf : the map
clhs_adelaide.R : cLHS vs random
rainfallr.R : rainfall 2015-2024 from SILO
slope.R : slope from TERN
output/ png/csv : results and point coordinates

Data: TERN Soil and Landscape Grid AWC 5-15 cm (doi:10.25919/4jwj-na34), TERN slope 1 arc-second (doi:10.25919/jr32-yq58), SILO rainfall, Atlas of Australian Soils (CSIRO)
