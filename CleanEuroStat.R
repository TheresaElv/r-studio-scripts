# ----------------------------------
# 01_load_clean_data.R
# Load and clean Eurostat dataset
# ----------------------------------
rm(list = ls())
library(tidyverse)
library(fixest)

setwd("/Users/theresaelverfeldt/Library/Mobile Documents/com~apple~CloudDocs/Mindestlohn Landwirtschaft/Data")

data_raw <- read_csv("DataSet__custom_20393195_linear_2_0.csv")

# Remove Eurostat metadata columns
data_clean <- data_raw %>%
  select(
    -starts_with("OBS_FLAG"),
    -starts_with("OBS_STATUS"),
    -starts_with("CONF"),
    -contains("observation value"),
    -contains("status")
  )

# Keep only relevant columns
data_clean <- data_clean %>%
  select(
    geo,
    Crops,
    TIME_PERIOD,
    OBS_VALUE,
    `Structure of production`
  )

# Rename variables
data_clean <- data_clean %>%
  rename(
    country   = geo,
    crop      = Crops,
    year      = TIME_PERIOD,
    value     = OBS_VALUE,
    indicator = `Structure of production`
  )

# Remove missing values in value and make year numeric
data_clean <- data_clean %>%
  filter(!is.na(value)) %>%
  mutate(year = as.integer(year))

# Keep only relevant crops
keep_crops <- c(
  "Asparagus",
  "Strawberries",
  "Apples",
  "Tomatoes",
  "Wheat and spelt",
  "Barley",
  "Rape and turnip rape seeds"
)

data_clean <- data_clean %>%
  filter(crop %in% keep_crops)

# Keep only Germany and Spain for now
data_clean <- data_clean %>%
  filter(country %in% c("DE", "ES"))

# Check indicators
table(data_clean$indicator)
table(data_clean$crop)
table(data_clean$country)

# Save cleaned object if you want
write_csv(data_clean, "data_cleanDE_ES.csv")
