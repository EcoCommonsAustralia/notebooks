## Install and Load packages
## Get and prepare data

# Convert data to an sf object for spatial plotting
combined_data_sf <- st_as_sf(combined_data, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)

# Plot occurrences on a map
ggplot(data = combined_data_sf) +
  geom_sf(aes(color = species), size = 1, alpha = 0.7) +
  labs(title = "Geographical Distribution of Shorebird Species",
       x = "Longitude",
       y = "Latitude",
       color = "Species") +
  theme_minimal()
