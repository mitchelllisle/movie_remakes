countByYear <- function(data){
  data <- data %>%
    group_by(year) %>%
    summarise(count = n())
  
  data$rolling_3 <- round(zoo::rollmean(data$count, 3, fill = "extend"), 2)
  data$rolling_10 <- round(zoo::rollmean(data$count, 10, fill = "extend"), 2)
  
  return(data)
}