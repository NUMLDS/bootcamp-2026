nys_merged = nys_schools_clean |>
  inner_join(nys_acs_clean, by = c("county_name", "year"))

write_csv(nys_merged, "data/processed/nys_merged.csv")
