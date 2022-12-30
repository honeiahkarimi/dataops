SELECT
sum(GR09_PI_M + GR09_PI_F + GR09_HS_M + GR09_HS_F +
GR09_BL_M + GR09_BL_F + GR09_AI_M + GR09_AI_F + GR10_PI_M + GR10_PI_F + GR10_HS_M + GR10_HS_F + 
GR10_BL_M + GR10_BL_F + GR10_AI_M + GR10_AI_F + GR11_PI_M + GR11_PI_F + 
    GR11_HS_M + GR11_HS_F + GR11_BL_M + GR11_BL_F + GR11_AI_M + GR11_AI_F + GR12_PI_M +
    GR12_PI_F + GR12_HS_M + GR12_HS_F + GR12_BL_M + GR12_BL_F + GR12_AI_M + GR12_AI_F) 
    as racialdiversity_9_12,
    sum(GR12_PI_M + GR12_PI_F + GR12_HS_M + GR12_HS_F + GR12_BL_M + GR12_BL_F + GR12_AI_M + GR12_AI_F) 
    as racialdiversity_12,
   ncessch
    
    from 

(

SELECT
cast(ncessch as varchar(40)) as ncessch,
cast(fips as smallint) as fips,
cast(gleaid as bigint) as gleaid,
cast(ncessch_num as bigint) as ncessch_num,
cast(ccd.leaid as bigint) as leaid,
cast(meps_poverty_pct as decimal(10,1)) as meps_poverty_pct,
cast(meps_poverty_se as decimal(10,1)) as meps_poverty_se,
cast(meps_poverty_ptl as bigint) as meps_poverty_ptl,
cast(meps_mod_poverty_pct as decimal(10,1)) as meps_mod_poverty_pct,
cast(meps_mod_poverty_ptl as bigint) as meps_mod_poverty_ptl,
cast(school_level as smallint) as school_level,
cast(count_12th_grade as smallint) as count_12th_grade,
cast(count_11th_grade as smallint) as count_11th_grade,
cast(count_10th_grade as smallint) as count_10th_grade,
cast(count_9th_grade as smallint) as count_9th_grade,
cast(charter_text as varchar(40)) as charter_text,
cast(sch_type_text as varchar(60)) as sch_type_text,
cast(level as varchar(40)) as level,
cast(titlei_status_text as varchar(40)) as titlei_status_text,
cast(magnet_text as varchar(40)) as magnet_text,
cast(nslp_status_text as varchar(40)) as nslp_status_text,
cast(virtual_text as varchar(40)) as virtual_text,
cast(latitude as decimal(12,6)) as latitude,
cast(longitude as decimal(12,6)) as longitude,
cast(teacher_fte as smallint) as teacher_fte,
cast(sch_name as varchar(60)) as sch_name,
cast(lea_name as varchar(60)) as lea_name,
cast(statename as varchar(100)) as statename,
cast(city as varchar(100)) as city,
cast(state_abbr as varchar(40)) as state_abbr,
cast(zip_code as bigint) as zip,
cast(GR09_PI_M as smallint) as GR09_PI_M,
cast(GR09_PI_F as smallint) as GR09_PI_F,
cast(GR09_HS_M as smallint) as GR09_HS_M,
cast(GR09_HS_F as smallint) as GR09_HS_F,
cast(GR09_BL_M as smallint) as GR09_BL_M,
cast(GR09_BL_F as smallint) as GR09_BL_F,
cast(GR09_AI_M as smallint) as GR09_AI_M,
cast(GR09_AI_F as smallint) as GR09_AI_F,
cast(GR10_PI_M as smallint) as GR10_PI_M,
cast(GR10_PI_F as smallint) as GR10_PI_F,
cast(GR10_HS_M as smallint) as GR10_HS_M,
cast(GR10_HS_F as smallint) as GR10_HS_F,
cast(GR10_BL_M as smallint) as GR10_BL_M,
cast(GR10_BL_F as smallint) as GR10_BL_F,
cast(GR10_AI_M as smallint) as GR10_AI_M,
cast(GR10_AI_F as smallint) as GR10_AI_F,
cast(GR11_PI_M as smallint) as GR11_PI_M,
cast(GR11_PI_F as smallint) as GR11_PI_F,
cast(GR11_HS_M as smallint) as GR11_HS_M,
cast(GR11_HS_F as smallint) as GR11_HS_F,
cast(GR11_BL_M as smallint) as GR11_BL_M,
cast(GR11_BL_F as smallint) as GR11_BL_F,
cast(GR11_AI_M as smallint) as GR11_AI_M,
cast(GR11_AI_F as smallint) as GR11_AI_F,
cast(GR12_PI_M as smallint) as GR12_PI_M,
cast(GR12_PI_F as smallint) as GR12_PI_F,
cast(GR12_HS_M as smallint) as GR12_HS_M,
cast(GR12_HS_F as smallint) as GR12_HS_F,
cast(GR12_BL_M as smallint) as GR12_BL_M,
cast(GR12_BL_F as smallint) as GR12_BL_F,
cast(GR12_AI_M as smallint) as GR12_AI_M,
cast(GR12_AI_F as smallint) as GR12_AI_F

from prod_adhoc_data_dar.urbn_highschool meps
LEFT JOIN 
(SELECT
  sch_name,
  lea_name,
  state_agency_no,
  st_leaid,
  leaid,
  st_schid, 
  ncesschid,
  schid,
  sch_type_text,
  charter_text,
  level,
  titlei_status_text,
  magnet_text,
  nslp_status_text,
  nslp_status,
  virtual_text,
  latitude,
  longitude,
  teacher_fte,
  count_9th_grade,
  count_10th_grade,
  count_11th_grade,
  count_12th_grade,
  statename,
  city, 
  state_abbr,
  zip_code,
  GR09_PI_M,
  GR09_PI_F,
  GR09_HS_M,
  GR09_HS_F,
  GR09_BL_M,
  GR09_BL_F,
  GR09_AI_M,
  GR09_AI_F, 
  GR10_PI_M,
  GR10_PI_F,
  GR10_HS_M,
  GR10_HS_F,
  GR10_BL_M, 
  GR10_BL_F,
  GR10_AI_M,
  GR10_AI_F,
  GR11_PI_M,
  GR11_PI_F,
  GR11_HS_M,
  GR11_HS_F,
  GR11_BL_M,
  GR11_BL_F,
  GR11_AI_M,
  GR11_AI_F,
  GR12_PI_M,
  GR12_PI_F,
  GR12_HS_M,
  GR12_HS_F,
  GR12_BL_M,
  GR12_BL_F,
  GR12_AI_M,
  GR12_AI_F
  
  from 
  prod_adhoc_data_dar.commoncore_highschool
  
) ccd

ON meps.ncessch = ccd.ncesschid

LEFT JOIN

(SELECT ncesschid, ceebid, nces_name
FROM prod_bidw_zone_2_db.dar_highschool_ceeb_crosswalk) cw

ON ccd.ncesschid = cw.ncesschid
                           
) test

GROUP BY ncessch