  library(jsonlite)
  library(tidyverse)
  library(stringr)
  
  data <- data.frame(read_json("data/movie_originals_remakes.json")$data)
  data <- read.csv("data/movieData.csv")
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
    
cleanMovieTitles <- data %>% 
mutate(title = str_extract(value, "^[^(]+"),
       title = str_replace_all(value, ".$", ""))

all_remake_data <- NULL
for(i in 1:nrow(cleanMovieTitles)){
  baseUrl <- "http://www.omdbapi.com/?t="
  key <- "49780c30"
  url <- URLencode(paste0(baseUrl, cleanMovieTitles$remakeClean_title[i], "&y=", cleanMovieTitles$remakes_year[i], "&apikey=", key))
  request <- httr::GET(url)
  
  data <- content(request)
  
  current_data <- list(Title = data$Title, year = data$Year, rated = data$Rated, released = data$Released, runtime = data$Runtime, genre = data$Genre, director = data$Director, awards = data$Awards, imdbrating = data$imdbRating, boxOffice = data$BoxOffice)
  
  current_data <- data.frame(nullToNAString(current_data))
  
  all_data <- rbind(all_data, current_data)
  cat(cleanMovieTitles$remakeClean_title[i], " ")
  cat(paste0(round(i/nrow(cleanMovieTitles)*100, 2), "%\n"))
}

cleanOriginal <- cleanMovieTitles %>% select(originalClean_title, originals_year) %>% distinct()  
all_original_data <- NULL
for(i in 1:nrow(cleanOriginal)){
  baseUrl <- "http://www.omdbapi.com/?t="
  key <- "49780c30"
  url <- URLencode(paste0(baseUrl, cleanOriginal$originalClean_title[i], "&y=", cleanOriginal$originals_year[i], "&apikey=", key))
  request <- httr::GET(url)
  
  data <- content(request)
  
  current_data <- list(Title = data$Title, year = data$Year, rated = data$Rated, released = data$Released, runtime = data$Runtime, genre = data$Genre, director = data$Director, awards = data$Awards, imdbrating = data$imdbRating, boxOffice = data$BoxOffice)
  
  current_data <- data.frame(nullToNAString(current_data))
  
  all_data <- rbind(all_data, current_data)
  cat(cleanMovieTitles$remakeClean_title[i], " ")
  cat(paste0(round(i/nrow(cleanMovieTitles)*100, 2), "%\n"))
}
