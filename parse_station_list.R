library(tidyverse)
library(readr)

col_widths <- c(8, 3, 7, 3, 6, 6, 5, 6, 5, 21, 3, 31, 6, 31, 31, 9, 9, 2, 3, 3, 3, 2, 4, 3, 3, 3, 7, 7, 3, 12, 51)
col_names <- c('STNIDNUM', 'RECTYPE', 'COOPID', 'CLIMDIV', 'WBANID', 'WMOID', 'FAAID', 'NWSID', 'ICAOID', 'COUNTRYNAME', 'STATEPROV', 'COUNTY', 'TIME_ZONE', 'COOPNAME', 'WBANNAME', 'BEGINDATE', 'ENDDATE', 'LATDIR', 'LAT_D', 'LAT_M', 'LAT_S', 'LONDIR', 'LON_D', 'LON_M', 'LON_S', 'LATLONPREC', 'EL_GROUND', 'EL_OTHER', 'ELEVOTHERTYPE', 'RELOC', 'STNTYPE')

read_df <- read_fwf('./mshr_standard.txt', col_positions = fwf_widths(col_widths, col_names))


# todo: filter out anything from earlier than the timeframe I am interested in
minimal_df <- read_df %>%
  filter(COUNTRYNAME == "UNITED STATES") %>%
  select(WBANID, COUNTY) %>%
  distinct(.keep_all = TRUE) %>%  # todo: is this keeping only unique values, or getting rid of duplicates?
  distinct(WBANID, .keep_all = TRUE) %>%
  drop_na()

write.csv(minimal_df, './station_county_lookup.csv')
