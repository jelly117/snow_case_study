library(tidyverse)
library(dplyr)

snow_df <- read.csv('./snow_days.csv')
freezing_df <- read.csv('./freezing_days.csv')

trend_calc <- function(df, dep_col_name, ind_col_name) {
  Formula <- as.formula(paste(paste(dep_col_name),"~",paste(ind_col_name)))
  
  lm_df <- df %>%
    group_by(state, county) %>%
    do(model = lm(Formula, data = .))

  new_df <- lm_df %>%
    mutate(trend = model[['coefficients']][2])  %>%
    mutate(model_elements = length(model[['fitted.values']])) %>%
    filter(model_elements >= 10) %>%
    subset(select = c('state', 'county', 'trend', 'model_elements'))
  
  return(new_df)
}

snow_trend <- trend_calc(snow_df, 'snow_days', 'year')
freezing_trend <- trend_calc(freezing_df, 'freezing_days', 'year')

write.csv(snow_trend, './snow_day_trends.csv')
write.csv(freezing_trend, './freezing_day_trends.csv')
