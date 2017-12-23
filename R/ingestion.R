  data <- data.frame(read_json("data/movie_originals_remakes.json")$data)
  data <- gather(data) %>% mutate(key = row_number(), 
                                  oddOrEven = if_else(key %% 2 == 0, "even", "odd"),
                                  year = str_extract(value, "\\([0-9]*?\\)"),
                                  year = str_replace_all(year, "\\(", ""),
                                  year = str_replace_all(year, "\\)", ""))
  
  remakes <- data %>% filter(oddOrEven == "odd")
  originals <- data %>% filter(oddOrEven == "even")
  
  movies <- list(remakes = remakes, originals = originals)
  
  write.csv(movies$remakes, "data/remakes.csv")
  write.csv(movies$originals, "data/originals.csv")  
  