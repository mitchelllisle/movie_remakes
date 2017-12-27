countByYear_chart <- function(data, colours, title){
  highchart() %>%
    hc_title(text = title, align = "left", margin = 20) %>%
    hc_xAxis(categories = unique(data$year)) %>%
    hc_add_series(data = data$count, type = "column", color = colours[1], name = "Count of Movies") %>% 
    # hc_add_series(data = data$rolling_3, type = "line", color = colours[2], name = "3 Year Rolling Average") %>% 
    hc_add_series(data = data$rolling_5, type = "line", color = colours[3], name = "5 Year Rolling Average")
    # hc_add_series(data = data$rolling_10, type = "line", color = colours[3], name = "10 Year Rolling Average")
}

tableWithBar <- function(data, colNames, barColour, range, pageLength = 30){
  datatable(data, class = "compact", colnames = colNames,
            options = list(dom = 't', pageLength = pageLength)) %>% 
            formatStyle(names(data),
                        background = styleColorBar(range(range), color = barColour, angle = -90),
                                                                        backgroundSize = '98% 88%',
                                                                        backgroundRepeat = 'no-repeat',
                                                                        backgroundPosition = 'right')
}

bubble_chart <- function(data, colours){
  hchart(data, hcaes(year, boxOffice, size = totalMovies, color = colours[1]), type = "bubble")
  
  highchart() %>%
    hc_xAxis(categories = unique(data$year)) %>%
    hc_add_series(data = data$boxOffice, size = data$totalMovies, type = "bubble", color = colours[1], name = "Count of Movies")
}