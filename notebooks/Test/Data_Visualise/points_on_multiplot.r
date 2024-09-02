## Install and Load packages
## Get and prepare data

install.packages("patchwork")
library(patchwork)

# Example combining two plots
p1 <- ggplot(data = combined_data_sf) +
  geom_sf(aes(color = species), size = 1, alpha = 0.7) +
  labs(title = "Geographical Distribution of Shorebird Species",
       x = "Longitude",
       y = "Latitude",
       color = "Species") +
  theme_minimal()

p2 <- ggplot(data = yearly_counts, aes(x = year, y = count, color = species)) +
  geom_line() +
  labs(title = "Yearly Occurrence Counts of Shorebird Species",
       x = "Year",
       y = "Number of Occurrences",
       color = "Species") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Combine plots
p1 + p2
