library(tidyverse)

billboard_long <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    values_to = "rank",
    values_drop_na = TRUE
  ) |>
  mutate(week = readr::parse_number(week))

top_songs <- billboard_long |>
  group_by(track, artist) |>
  summarise(best = min(rank), .groups = "drop") |>
  slice_min(best, n = 15, with_ties = FALSE)


write_rds(billboard_long, file = "clean_data.rds")
  