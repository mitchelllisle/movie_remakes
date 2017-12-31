countByYear_chart <- function(data, colours, title, subtitle, source, link){
  highchart() %>%
    hc_title(text = paste0("<b>", title, "</b>"), align = "left", margin = 20) %>%
    hc_subtitle(text = subtitle, align = "left") %>%
    hc_credits(enabled = TRUE, text = source, href = link, position = list(align = "left", x = 12)) %>%
    hc_xAxis(categories = unique(data$year)) %>%
    hc_add_series(data = data$count, type = "column", color = colours[1], name = "Count of Movies") %>% 
    # hc_add_series(data = data$rolling_3, type = "line", color = colours[2], name = "3 Year Rolling Average") %>% 
    hc_add_series(data = data$rolling_5, type = "line", color = colours[3], name = "5 Year Rolling Average")
    # hc_add_series(data = data$rolling_10, type = "line", color = colours[3], name = "10 Year Rolling Average")
}

popularRemakes_chart <- function(data, colours, title, subtitle, source, link){
  hchart(data, hcaes(remakes_key, as.numeric(imdbrating), color = colours, label = remakes_year), type = "bar", height = "200px") %>% 
  hc_plotOptions(bar = list(stacking = "null")) %>% 
  hc_xAxis(title = list(enabled = FALSE)) %>% 
  hc_yAxis(title = list(enabled = FALSE)) %>%
  hc_chart(height = "200") %>%
  hc_title(text = paste0("<b>", title, "</b>"), align = "left", margin = 20) %>%
  hc_subtitle(text = subtitle, align = "left") %>%
  hc_credits(enabled = TRUE, text = source, href = link, position = list(align = "left", x = 12))
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

barChart <- function(data){
  hchart(data, hcaes(primaryGenre, as.numeric(percentage), color = colours[1]), type = "bar")
}

# df <- data.frame(key = c('phone', 'income'), value = c(10, 90))
# 
# hchart(df, hcaes(key, value, color = colours), type = "treemap")
