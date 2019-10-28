library(dplyr)
library(tidyr)
library(rio)
library(purrr)
library(here)
setwd(here())

migrants <- import('module2/migrant_entries_raw.xls')
# we get rid of the initial headers
migrants <- migrants %>% tail(-12) %>% head(-28)
# and change column names
colnames(migrants) <- c('Country', as.character(2005:2018), 'empty')
# get rid of unnecesary columns without values and of the rows with
# totals
migrants <- migrants %>% 
    drop_na(Country, '2005') %>% 
    filter(Country != 'Continente/ nacionalidad') %>% 
    select(-empty)


available_regions <- c('América del Norte', 'América Central', 
                       'Islas del Caribe', 'América del Sur', 'Europa',
                       'Asia', 'Oceanía', 'África')

list_item <- 1
regions = list()
this_region <- data.frame()

for (i in 1:nrow(migrants)) {
    if (migrants$Country[i] %in% available_regions)  {
        regions[[list_item]] <- this_region
        list_item <- list_item + 1
        this_region <- data.frame()
        next()
    }
    this_region <- rbind(this_region, migrants[i,])
}
regions[[list_item]] <- this_region


regions[[1]] <- NULL
names(regions) <- available_regions

# I add a column that indicates the region explicitly
for (i in 1:length(regions)) {
    temp <- regions[[i]]
    temp$region <- available_regions[i]
    regions[[i]] <- temp
}

export(bind_rows(regions), 'migrant_entries_clean.csv')
