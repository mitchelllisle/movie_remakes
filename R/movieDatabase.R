library(jsonlite)
library(tidyverse)
library(stringr)
library(httr)

movieData <- read.csv("data/movieData.csv") %>%
  mutate(releaseYear = str_extract(longTitle, "\\([0-9]*?\\)"),
  releaseYear = str_replace_all(releaseYear, "\\(", ""),
  releaseYear = str_replace_all(releaseYear, "\\)", "")) %>%
  mutate(shortTitle = str_extract(longTitle, "^[^(]+"))

movieMetaData <- NULL
for(i in 1:nrow(movieData)){
  baseUrl <- "http://www.omdbapi.com/?t="
  key <- "49780c30"
  tryCatch({
    url <- URLencode(paste0(baseUrl, movieData$shortTitle[i], "&y=", movieData$releaseYear[i], "&apikey=", key))
    request <- httr::GET(url)
  }, error = function(e){
    data <- NULL
  })

  data <- content(request)
  
  current_data <- list(Title = data$Title, year = data$Year, rated = data$Rated, released = data$Released, runtime = data$Runtime, genre = data$Genre, director = data$Director, awards = data$Awards, imdbrating = data$imdbRating, boxOffice = data$BoxOffice)
  
  current_data <- data.frame(dime::nullToNAString(current_data))
  
  movieMetaData <- rbind(movieMetaData, current_data)
  cat(movieData$shortTitle[i], " ")
  cat(paste0(round(i/nrow(movieData)*100, 2), "%\n"))
}

movieMetaData <- filter(movieMetaData, !is.na(Title))
write.csv(movieMetaData, "data/movieData.csv")
