library(curl)
library(dplyr)

index <- curl_fetch_memory(url = 'https://otexts.com/fpp2/')
rawToChar(index$content)

library(rvest)
library(purrr)

index <- read_html('https://otexts.com/fpp2/')

chapters <- html_nodes(index, '.chapter')

html_attr(chapters[[4]], 'data-level')

chapter_extracter <- function(chapter){
  href <- html_nodes(chapter, 'a') %>%
    html_attr('href')

  data_level <- html_attr(chapter, 'data-level')

  return(tibble('href' = href, 'data_level' = data_level))
}


chapters_info <- map_df(chapters, chapter_extracter)

chapters_info <- chapters_info %>%
  group_by(data_level) %>%
  slice(1)

index %>%
  html_node('.book-body') %>%
  html_text() %>%
  save(., file = 'test.txt')
  write_html(file = 'test.html')
