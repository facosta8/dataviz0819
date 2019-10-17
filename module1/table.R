library(rvest)
library(tibble)
library(rio)

url <- "https://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&plugin=1&language=en&pcode=tec00115"

gdp_table <- read_html(url) %>% 
    html_nodes('table') %>% 
    html_table()

column_names <- names(gdp_table[[4]])
country_list <- c(names(gdp_table[[5]]), gdp_table[[5]][[1]])
country_values <- gdp_table[[6]]
                      
gdp <- as_tibble(country_values)
colnames(gdp) <- column_names
gdp$country <- country_list

gdp <- gdp %>% 
    dplyr::select(country, `2007`:`2018`)


export(gdp, 'gdp.csv')