countByYear_chart <- function(data, title, colours){
  highchart() %>%
    hc_xAxis(categories = unique(data$year)) %>%
    hc_add_series(data = data$count, type = "column", color = colours[1], name = "Count of Movies") %>% 
    hc_add_series(data = data$rolling_3, type = "line", color = colours[2], name = "3 Year Rolling Average") %>% 
    hc_add_series(data = data$rolling_10, type = "line", color = colours[3], name = "10 Year Rolling Average") %>% 
    hc_title(text = title)
}
