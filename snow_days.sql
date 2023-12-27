with max_county_snow_depth as (
SELECT 
  stations.state as state,
  county_lookup.COUNTY as county,
  yearly_data.year as year,
  yearly_data.mo as month,
  yearly_data.da as day,
  max(yearly_data.sndp) as max_snow_depth
FROM `snow-data-project.station_lookup.county_lookup` as county_lookup
join `bigquery-public-data.noaa_gsod.stations` as stations
  on cast(county_lookup.WBANID as string) = stations.wban
join (select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2022`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2021`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2020`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2019`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2018`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2017`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2016`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2015`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2014`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2013`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2012`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2011`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2010`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2009`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2008`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2007`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2006`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2005`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2004`
      union all
      select wban, year, mo, da, sndp
      from `bigquery-public-data.noaa_gsod.gsod2013`) as yearly_data
  on cast(county_lookup.WBANID as string) = yearly_data.wban
where 
  yearly_data.sndp != 999.9
group by 
  stations.state, 
  county_lookup.COUNTY,
  yearly_data.year,
  yearly_data.mo,
  yearly_data.da
)

select 
  max_county_snow_depth.state,
  max_county_snow_depth.county,
  max_county_snow_depth.year,
  count(*) as snow_days
from max_county_snow_depth
where 
  max_county_snow_depth.max_snow_depth >= 1
group by 
  max_county_snow_depth.state,
  max_county_snow_depth.county,
  max_county_snow_depth.year
