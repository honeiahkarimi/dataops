# set working directory
setwd("~/Desktop/DataOps/2020-2021")

# import library
library(educationdata)
library(tidyverse)

# api call for ccd
df_ccd <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = "directory", 
                         filters = list(year = 2020, school_level = 3)) # 3 is for high school

# api call for meps
df_meps <- get_education_data(level = 'schools', 
                         source = 'meps', 
                         filters = list(year = 2018))

# joining two datasets
df_all <- inner_join(df_meps, df_ccd, by = c('ncessch'='ncessch', 'leaid'='leaid',
                                            'fips'='fips', 'ncessch_num'='ncessch_num')) %>% 
  select(ncessch, fips, gleaid, ncessch, ncessch_num, leaid, meps_poverty_pct, meps_poverty_se, 
         meps_poverty_ptl, meps_mod_poverty_pct, meps_mod_poverty_ptl, school_level) %>% # select only necessary variables
  drop_na() # remove NAs

# save as csv
write.csv(df_all, "urbaninstitute_api_data.csv", row.names = FALSE)

