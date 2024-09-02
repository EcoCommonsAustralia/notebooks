## Install and Load packages
## Get and prepare data

# Aggregate data by year
yearly_counts <- combined_data %>%
  mutate(year = format(eventDate, "%Y")) %>%
  group_by(year, species) %>%
  summarise(count = n(), .groups = 'drop')

# Plot occurrences over time
ggplot(data = yearly_counts, aes(x = year, y = count, color = species)) +
  geom_line() +
  labs(title = "Yearly Occurrence Counts of Shorebird Species",
       x = "Year",
       y = "Number of Occurrences",
       color = "Species") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
