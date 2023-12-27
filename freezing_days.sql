with max_county_temp as (
SELECT 
  stations.state as state,
  county_lookup.COUNTY as county,
  yearly_data.year as year,
  yearly_data.mo as month,
  yearly_data.da as day,
  max(yearly_data.max) as max_temperature
FROM `snow-data-project.station_lookup.county_lookup` as county_lookup
join `bigquery-public-data.noaa_gsod.stations` as stations
  on cast(county_lookup.WBANID as string) = stations.wban
join (select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2022`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2021`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2020`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2019`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2018`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2017`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2016`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2015`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2014`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2013`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2012`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2011`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2010`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2009`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2008`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2007`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2006`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2005`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2004`
      union all
      select wban, year, mo, da, max
      from `bigquery-public-data.noaa_gsod.gsod2013`) as yearly_data
  on cast(county_lookup.WBANID as string) = yearly_data.wban
group by 
  stations.state, 
  county_lookup.COUNTY,
  yearly_data.year,
  yearly_data.mo,
  yearly_data.da
)

select 
  max_county_temp.state,
  max_county_temp.county,
  max_county_temp.year,
  count(*) as freezing_days
from max_county_temp
where max_county_temp.max_temperature < 32
group by 
  max_county_temp.state,
  max_county_temp.county,
  max_county_temp.year

