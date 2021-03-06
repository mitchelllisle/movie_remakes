countByYear <- function(data){
  data <- data %>%
    group_by(year) %>%
    summarise(count = n())
  
  data$rolling_3 <- round(zoo::rollmean(data$count, 3, fill = "extend"), 2)
  data$rolling_5 <- round(zoo::rollmean(data$count, 5, fill = "extend"), 2)
  data$rolling_10 <- round(zoo::rollmean(data$count, 10, fill = "extend"), 2)
  
  return(data)
}

mostRemadeMovies <- function(data){
  data <- data %>%
    group_by(originals_title) %>%
    summarise(count = n()) %>%
    arrange(desc(count))
  
  return(data)
}

mostPopularRemakes <- function(data, movieMetaData){
  remakes <- rename(remakes, "key" = remakes_key)
  joinData <- remakes %>% left_join(movieMetaData, by = 'key')
  joinData %>% filter(!is.na(Title)) %>%
    select(Title, released, imdbrating) %>%
    mutate(imdbrating = as.numeric(imdbrating)) %>%
    filter(!is.na(imdbrating)) %>%
    arrange(desc(imdbrating))
}

medianBoxOfficebyYear <- function(remakes, movieMetaData){
  medianBoxOfficebyYear <- remakes %>% left_join(movieMetaData, by = c("remakes_key" = "key")) %>%
    select(year.x, boxOffice, imdbrating) %>%
    filter(!is.na(year.x), boxOffice != "N/A") %>%
    mutate(boxOffice = str_replace_all(boxOffice, ",", ""),
           boxOffice = str_replace_all(boxOffice, "\\$", "")) %>%
    group_by(year.x) %>%
    summarise(boxOffice = median(as.numeric(boxOffice)),
              averageRating = mean(as.numeric(imdbrating)),
              totalMovies = n()) %>%
    rename("year" = year.x)
  
  return(medianBoxOfficebyYear)
}
