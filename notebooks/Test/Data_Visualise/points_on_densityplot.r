## Install and Load packages
## Get and prepare data

# Plot density of occurrences
ggplot(data = combined_data_sf) +
  stat_density_2d(aes(fill = ..level..), geom = "raster", contour = TRUE) +
  scale_fill_viridis_c() +
  labs(title = "Density of Shorebird Occurrences",
       x = "Longitude",
       y = "Latitude",
       fill = "Density") +
  theme_minimal()
