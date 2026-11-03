library(tidyverse)

billboard_long <- read_rds("clean_data.rds")

top_hits <- billboard_long |>
  group_by(track, artist) |>
  summarise(best = min(rank), .groups = "drop") |>
  slice_min(best, n = 15, with_ties = FALSE)

billboard_plot <- billboard_long |>
  semi_join(top_hits, by = c("track", "artist")) |>
  ggplot(
    aes(
      week,
      rank,
      color = track,
      group = interaction(track, artist)
    )
  ) +
  geom_line(linewidth = 1.2) +
  scale_y_reverse() +
  labs(
    title = "Rise and Fall of Billboard Hits",
    subtitle = "Chart trajectories of top-performing songs",
    x = "Weeks on Chart",
    y = "Billboard Rank"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 22)
  )

ggsave("billboard.png", plot = billboard_plot, width = 10, height = 6, dpi = 300)
