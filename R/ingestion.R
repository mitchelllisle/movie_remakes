  library(jsonlite)
  library(tidyverse)
  library(stringr)
  
  data <- data.frame(read_json("data/movie_originals_remakes.json")$data)
  data <- gather(data) %>% mutate(key = row_number(), 
                                  oddOrEven = if_else(key %% 2 == 0, "even", "odd"),
                                  year = str_extract(value, "\\([0-9]*?\\)"),
                                  year = str_replace_all(year, "\\(", ""),
                                  year = str_replace_all(year, "\\)", ""))
  
  remakes <- data %>% filter(oddOrEven == "odd")
  names(remakes) <- c("remakes_row", "remakes_title", "remake_class", "remakes_year")
  
  originals <- data %>% filter(oddOrEven == "even")
  names(originals) <- c("original_row", "originals_title", "originals_class", "originals_year")
  
  all_movies <- cbind(remakes, originals) 
  all_movies <- all_movies %>% select(c(-contains("class"), -contains("row")))
  all_movies <- all_movies %>% 

  write.csv(all_movies, "data/allMovies.csv")
  write.csv(remakes, "data/remakes.csv")
  write.csv(originals, "data/originals.csv")  
  
    data <- read.csv("data/allMovies.csv") %>%
   mutate(remakes_year = str_extract(remakes_title, "\\([0-9]*?\\)"),
          remakes_year = str_replace_all(remakes_year, "\\(", ""),
          remakes_year = str_replace_all(remakes_year, "\\)", "")) %>%
        mutate(yearsBetween = as.numeric(remakes_year) - as.numeric(originals_year))

  write.csv(data, "data/allMovies.csv")

  
  
  
# IMDB API Fetch
library(httr)
library(tidyverse)
library(stringr)
    
allMovies <- read.csv("data/allMovies.csv")

cleanMovieTitles <- allMovies %>% 
mutate(remakeClean_title = str_extract(remakes_title, "^[^(]+"),
       remakeClean_title = str_replace_all(remakeClean_title, ".$", "")) %>%
mutate(originalClean_title = str_extract(originals_title, "^[^(]+"),
       originalClean_title = str_replace_all(originalClean_title, ".$", ""))
  
all_data <- NULL

for(i in 1:nrow(cleanMovieTitles)){
  baseUrl <- "http://www.omdbapi.com/?t="
  key <- "49780c30"
  url <- URLencode(paste0(baseUrl, cleanMovieTitles$remakeClean_title[i], "&y=", cleanMovieTitles$remakes_year[i], "&apikey=", key))
  request <- httr::GET(url)
  
  data <- content(request)
  
  current_data <- data.frame(Title = data$Title, year = data$Year, rated = data$Rated, released = data$Released, runtime = data$Runtime, genre = data$Genre, director = data$Director, awards = data$Awards, imdbrating = data$imdbRating, boxOffice = data$BoxOffice)
  
  all_data <- rbind(all_data, current_data)
  cat(cleanMovieTitles$remakeClean_title[i], "\n")
  cat(round(i/nrow(cleanMovieTitles), 2), "%\n")
}
