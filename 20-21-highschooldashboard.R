# ccd_2021_extract.R
# Created 2022-08-24
rm(list=ls())

# Load libraries
pacman::p_load(tidyverse, vtable, readr, readxl)

# Set working directory
setwd("~/Desktop/DataOps/2020-2021")

directory <- readr::read_csv(unzip("ccd_sch_029_2021_w_1a_080621.zip",
                                   "ccd_sch_029_2021_w_1a_080621.csv"))
directory <- directory %>% filter(LEVEL %in% c('High','Adult Education', 
                                               'Not applicable', 'Not reported',
                                               'Other', 'Secondary', 'Ungraded')) %>%
  select(SCHOOL_YEAR, FIPST,STATENAME,ST,SCH_NAME,LEA_NAME,STATE_AGENCY_NO,UNION,
         ST_LEAID,   LEAID,ST_SCHID,NCESSCH, SCHID,
         EFFECTIVE_DATE, SCH_TYPE_TEXT, SCH_TYPE,  RECON_STATUS, OUT_OF_STATE_FLAG,
         CHARTER_TEXT,   CHARTAUTH1,   CHARTAUTHN1, CHARTAUTH2, CHARTAUTHN2, G_9_OFFERED, G_10_OFFERED,
         G_11_OFFERED, G_12_OFFERED, G_13_OFFERED, G_UG_OFFERED,
         G_AE_OFFERED, GSLO, GSHI, LEVEL, IGOFFERED)
hs_ncesid <- directory %>% select(NCESSCH)

teachers <- readr::read_csv(unzip("ccd_sch_059_2021_l_1a_080621.zip",
                                  "ccd_sch_059_2021_l_1a_080621.csv")) # WIDE
teachers <- inner_join(hs_ncesid, teachers) %>%
  select(NCESSCH, SCHOOL_YEAR, TEACHERS) %>%
  mutate(TEACHERS = round(replace_na(TEACHERS,-9),0))

characteristics <- readr::read_csv(unzip("ccd_sch_129_2021_w_1a_080621.zip",
                                         "ccd_sch_129_2021_w_1a_080621.csv")) # WIDE
characteristics <- inner_join(hs_ncesid, characteristics) %>%
  select(NCESSCH, SCHOOL_YEAR, SHARED_TIME, TITLEI_STATUS, TITLEI_STATUS_TEXT,
         MAGNET_TEXT, NSLP_STATUS, NSLP_STATUS_TEXT, VIRTUAL, VIRTUAL_TEXT)

geodata <- read_excel("EDGE_GEOCODE_PUBLICSCH_2021.xlsx") # WIDE
geodata <- left_join(hs_ncesid, geodata) %>% select(-LEAID, -NAME, -SCHOOLYEAR)

cuboulder_xwalk <- read.csv('oda_nces_ceeb_crosswalk.csv',
                            header = TRUE,
                            colClasses = 'character') %>%
  rename(NCESSCH = HS_NCES) %>%
  select(HS_CEEB, NCESSCH) %>%
  distinct()

test1 <- cuboulder_xwalk %>% group_by(HS_CEEB) %>% summarise(n = n())

#### Flatten files ####
membership <- readr::read_csv("ccd_sch_052_2021_l_1a_080621.csv") # LONG
membership <- inner_join(hs_ncesid, membership)

membership <- membership %>% select(-DMS_FLAG) %>%
  filter(GRADE %in% c('Adult Education', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12',
                      'No Category Codes','Not Specified', 'Ungraded')) %>%
  unite(concated_column,GRADE, RACE_ETHNICITY, SEX,TOTAL_INDICATOR, sep = '_') %>% 
  mutate(STUDENT_COUNT = replace_na(STUDENT_COUNT,-9)) %>%
  pivot_wider(names_from = concated_column, values_from = STUDENT_COUNT) %>%
  rename(MISSING_TOT='Not Specified_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         STUDENT_COUNT='No Category Codes_No Category Codes_No Category Codes_Derived - Education Unit Total minus Adult Education Count',
         AI_F_TOT='No Category Codes_American Indian or Alaska Native_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         AI_M_TOT='No Category Codes_American Indian or Alaska Native_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         AS_F_TOT='No Category Codes_Asian_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         AS_M_TOT='No Category Codes_Asian_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         BL_F_TOT='No Category Codes_Black or African American_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         BL_M_TOT='No Category Codes_Black or African American_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         HS_F_TOT='No Category Codes_Hispanic/Latino_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         HS_M_TOT='No Category Codes_Hispanic/Latino_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         PI_F_TOT='No Category Codes_Native Hawaiian or Other Pacific Islander_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         PI_M_TOT='No Category Codes_Native Hawaiian or Other Pacific Islander_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         UK_UK_TOT='No Category Codes_Not Specified_Not Specified_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         TM_F_TOT='No Category Codes_Two or more races_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         TM_M_TOT='No Category Codes_Two or more races_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         WH_F_TOT='No Category Codes_White_Female_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         WH_M_TOT='No Category Codes_White_Male_Derived - Subtotal by Race/Ethnicity and Sex minus Adult Education Count',
         TOTAL_INCL_AD='No Category Codes_No Category Codes_No Category Codes_Education Unit Total',
         DELETE='Not Specified_Not Specified_Not Specified_Subtotal 4 - By Grade',
         GR10_AI_F='Grade 10_American Indian or Alaska Native_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_AI_M='Grade 10_American Indian or Alaska Native_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_AS_F='Grade 10_Asian_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_AS_M='Grade 10_Asian_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_BL_F='Grade 10_Black or African American_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_BL_M='Grade 10_Black or African American_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_HS_F='Grade 10_Hispanic/Latino_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_HS_M='Grade 10_Hispanic/Latino_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_PI_F='Grade 10_Native Hawaiian or Other Pacific Islander_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_PI_M='Grade 10_Native Hawaiian or Other Pacific Islander_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_UK_UK='Grade 10_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_TM_F='Grade 10_Two or more races_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_TM_M='Grade 10_Two or more races_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_WH_F='Grade 10_White_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR10_WH_M='Grade 10_White_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_AI_F='Grade 11_American Indian or Alaska Native_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_AI_M='Grade 11_American Indian or Alaska Native_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_AS_F='Grade 11_Asian_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_AS_M='Grade 11_Asian_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_BL_F='Grade 11_Black or African American_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_BL_M='Grade 11_Black or African American_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_HS_F='Grade 11_Hispanic/Latino_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_HS_M='Grade 11_Hispanic/Latino_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_PI_F='Grade 11_Native Hawaiian or Other Pacific Islander_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_PI_M='Grade 11_Native Hawaiian or Other Pacific Islander_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_UK_UK='Grade 11_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_TM_F='Grade 11_Two or more races_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_TM_M='Grade 11_Two or more races_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_WH_F='Grade 11_White_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR11_WH_M='Grade 11_White_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_AI_F='Grade 12_American Indian or Alaska Native_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_AI_M='Grade 12_American Indian or Alaska Native_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_AS_F='Grade 12_Asian_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_AS_M='Grade 12_Asian_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_BL_F='Grade 12_Black or African American_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_BL_M='Grade 12_Black or African American_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_HS_F='Grade 12_Hispanic/Latino_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_HS_M='Grade 12_Hispanic/Latino_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_PI_F='Grade 12_Native Hawaiian or Other Pacific Islander_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_PI_M='Grade 12_Native Hawaiian or Other Pacific Islander_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_UK_UK='Grade 12_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_TM_F='Grade 12_Two or more races_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_TM_M='Grade 12_Two or more races_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_WH_F='Grade 12_White_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR12_WH_M='Grade 12_White_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_AI_F='Grade 9_American Indian or Alaska Native_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_AI_M='Grade 9_American Indian or Alaska Native_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_AS_F='Grade 9_Asian_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_AS_M='Grade 9_Asian_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_BL_F='Grade 9_Black or African American_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_BL_M='Grade 9_Black or African American_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_HS_F='Grade 9_Hispanic/Latino_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_HS_M='Grade 9_Hispanic/Latino_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_PI_F='Grade 9_Native Hawaiian or Other Pacific Islander_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_PI_M='Grade 9_Native Hawaiian or Other Pacific Islander_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_UK_UK='Grade 9_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_TM_F='Grade 9_Two or more races_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_TM_M='Grade 9_Two or more races_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_WH_F='Grade 9_White_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         GR09_WH_M='Grade 9_White_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         COUNT_10TH_GRADE='Grade 10_No Category Codes_No Category Codes_Subtotal 4 - By Grade',
         COUNT_11TH_GRADE='Grade 11_No Category Codes_No Category Codes_Subtotal 4 - By Grade',
         COUNT_12TH_GRADE='Grade 12_No Category Codes_No Category Codes_Subtotal 4 - By Grade',
         COUNT_9TH_GRADE='Grade 9_No Category Codes_No Category Codes_Subtotal 4 - By Grade',
         NOGR_AI_F='Ungraded_American Indian or Alaska Native_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_AI_M='Ungraded_American Indian or Alaska Native_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_AS_F='Ungraded_Asian_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_AS_M='Ungraded_Asian_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_BL_F='Ungraded_Black or African American_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_BL_M='Ungraded_Black or African American_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_HS_F='Ungraded_Hispanic/Latino_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_HS_M='Ungraded_Hispanic/Latino_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_PI_F='Ungraded_Native Hawaiian or Other Pacific Islander_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_PI_M='Ungraded_Native Hawaiian or Other Pacific Islander_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_UK_UK='Ungraded_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_TM_F='Ungraded_Two or more races_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_TM_M='Ungraded_Two or more races_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_WH_F='Ungraded_White_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_WH_M='Ungraded_White_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         NOGR_TOT='Ungraded_No Category Codes_No Category Codes_Subtotal 4 - By Grade',
         ADED_AI_F='Adult Education_American Indian or Alaska Native_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_AI_M='Adult Education_American Indian or Alaska Native_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_AS_F='Adult Education_Asian_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_AS_M='Adult Education_Asian_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_BL_F='Adult Education_Black or African American_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_BL_M='Adult Education_Black or African American_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_HS_F='Adult Education_Hispanic/Latino_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_HS_M='Adult Education_Hispanic/Latino_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_PI_F='Adult Education_Native Hawaiian or Other Pacific Islander_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_PI_M='Adult Education_Native Hawaiian or Other Pacific Islander_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_UK_UK='Adult Education_Not Specified_Not Specified_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_TM_F='Adult Education_Two or more races_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_TM_M='Adult Education_Two or more races_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_WH_F='Adult Education_White_Female_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_WH_M='Adult Education_White_Male_Category Set A - By Race/Ethnicity; Sex; Grade',
         ADED_TOT='Adult Education_No Category Codes_No Category Codes_Subtotal 4 - By Grade') %>%
  select(-FIPST, -STATENAME, -ST, -SCH_NAME, -STATE_AGENCY_NO, -UNION, -ST_LEAID, -LEAID, -ST_SCHID, -SCHID, -DELETE)


lunch <- readr::read_csv(unzip("ccd_sch_033_2021_l_1a_080621.zip",
                               "ccd_sch_033_2021_l_1a_080621.csv")) # LONG
lunch <- inner_join(hs_ncesid, lunch)
lunch <- lunch %>% select(-DMS_FLAG) %>%
  unite(concated_column,DATA_GROUP, LUNCH_PROGRAM, TOTAL_INDICATOR, sep = '_') %>% 
  mutate(STUDENT_COUNT = replace_na(STUDENT_COUNT,-9)) %>%
  pivot_wider(names_from = concated_column, values_from = STUDENT_COUNT) %>%
  rename(FreeLunchQualified= 'Free and Reduced-price Lunch Table_Free lunch qualified_Category Set A',
         ReducedLunchQualified= 'Free and Reduced-price Lunch Table_Reduced-price lunch qualified_Category Set A',
         TotLunchQualified= 'Free and Reduced-price Lunch Table_No Category Codes_Education Unit Total',
         DirectCertLunch= 'Direct Certification_Not Applicable_Education Unit Total') %>%
  select(NCESSCH, SCHOOL_YEAR, FreeLunchQualified, ReducedLunchQualified, TotLunchQualified, DirectCertLunch)


### test
test <- left_join(directory, characteristics)
test <- left_join(test, geodata)
test <- left_join(test, teachers)
test <- left_join(test, lunch)
test <- left_join(test, membership)
# Notes, because there are duplicates in the cuboulder_xwalk, we have dupes in the final ccd dataset.
# this intimates that we should keep the ceeb nces xwalk separate

test <- test %>% rename(NCESSCHID = NCESSCH,
                        STATE_ABBR = STATE,
                        LOWEST_GRADE_LEVEL = GSLO,
                        HIGHEST_GRADE_LEVEL = GSHI,
                        ZIP_CODE = ZIP,
                        COUNTY_FIPS = CNTY,
                        COUNTY_NAME = NMCNTY,
                        LATITUDE = LAT,
                        LONGITUDE = LON,
                        TEACHER_FTE = TEACHERS) %>%
  select(-ST, -UNION)

names(test) <- tolower(names(test))

write_csv(test, 'ccd_v0_2021.csv', na = '')