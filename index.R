library(jsonlite)
library(tidyverse)
library(stringr)
library(highcharter)

source("R/processing.R")

data <- data.frame(read_json("data/Scrape_URL-1513988393050.json")$data)
data <- gather(data) %>% mutate(key = row_number(), 
                                oddOrEven = if_else(key %% 2 == 0, "even", "odd"),
                                year = str_extract(value, "\\([0-9]*?\\)"),
                                year = str_replace_all(year, "\\(", ""),
                                year = str_replace_all(year, "\\)", ""))

remakes <- data %>% filter(oddOrEven == "odd")
originals <- data %>% filter(oddOrEven == "even")



