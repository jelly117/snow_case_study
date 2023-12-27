Snow Case Study
================
Ross Hjelle
2023-12-20

## Introduction

My wife and I currently live in the US state of Idaho. Due to various
reasons we are considering a move elsewhere. We enjoy living in a place
which experiences all four seasons. We particularly enjoy winter because
cross-country skiing is a favorite pass time of ours. This means
anywhere we consider moving to **must** have at least some winter
weather. Just as importantly, that place should *continue* to experience
winter weather as our climate warms.

Some of the areas we have considered for a potential future move
include:  
- Upper Midwest (Minnesota, Wisconsin, etc.)  
- New England (New York, Vermont, etc.)  
- Pacific Northwest (Washington, Oregon)

In the rest of this case study I will attempt to determine if any of
those areas will meet our winter requirement, or if there are other
parts of the country we should consider.

## Plan

First I will need to find a dataset which includes information about
temperature and snow. I will aggregate this data at a county level. Many
states are large enough to have significant variation from one part of
the state to another, while analyzing data for individual cities or
weather stations could become very cumbersome. My hope is that working
at a county level will be a nice balance between capturing local weather
variations while still being relatively easy to analyze the data. I
would like to find data going back at least 10-20 years so I can look at
trends over time.

Once I have the data, it will be time to perform some analysis. The two
metrics I plan to look at are the number of days each year with snow on
the ground and the number of days each year with a high temperature
below freezing (32F).

## Data

My primary data source will be [NOAA
GSOD](https://console.cloud.google.com/marketplace/details/noaa-public/gsod)
(National Oceanic and Atmospheric Association Global Summary of the
Day), accessed via the Google BigQuery public datasets. This dataset
contains daily weather observations including snow depth and maximum
temperature, going back to 1929.

This dataset includes the country and state where each weather station
is located, but not the county. I will need to find a way to determine
the county for each weather station. The
[mshr_standard](https://www.ncei.noaa.gov/access/homr/reports/mshr)
dataset proved useful for this. The MSHR data included WBAN ID and
county for a large number of weather stations. I can parse this data and
import it to BigQuery, enabling me to determine the county of each
weather station directly within my SQL queries.

One difficulty I encountered with the MSHR data is that weather stations
occasionally move. This results in multiple entries for many stations.
In some cases one station even moved from one county to another! To keep
things simple I will simply reject any stations with multiple entries.
This does reduce the pool of data I can use for analysis, but will be
much simpler than trying to account for these moving weather stations.
For example, I could try to match based on latitude and longitude.

#### describe sql queries here?

## Analysis

#### Days with snow

I started by looking at the number of days with snow on the ground for
each county. This was measured as the number of days during each year
where at least one station within the county reported a snow depth of at
least one inch. Using this data I created [this Tableau
dashboard](https://public.tableau.com/views/snow_days/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link).
I was surprised to see many counties without any snow reported, even in
areas which definitely receive snow. I suspect this is due to a couple
factors. First, my method for determining the county each station is
located in relies on matching the WBAN ID from the GSOD and MSHR
datasets. Second, it is possible not all weather stations report snow
depth. The combination of those two factors significantly reduces the
number of weather stations available to analyze the number of snow days.
Despite this some patterns do emerge, particularly when filtering for
counties with 80+ snow days in a given year. The Upper Midwest (North
Dakota, Minnesota, Wisconsin, and Michigan), along with New England (New
York, Vermont, New Hampshire, and Maine) seem to consistently have
counties with 80+ days of snow each year.

Next I looked at how the number of snow days has changed over the years.
To do this I performed a linear regression for each county, then pulled
the slope coefficient from the regression model. This analysis is very
basic and not suitable for predictive purposes (weather and climate are
extremely complicated), but it should provide a general idea of any long
term trends. The resulting data is provided in [a Tableau
dashboard](https://public.tableau.com/app/profile/ross.hjelle/viz/snow_day_trends/Dashboard1).
Again, due to the sparseness of the data I’m working with it is
difficult to draw any definite conclusions. It does appear an area
centered around Michigan is seeing descreasing snow days, while some
areas around Minnesota and western Montana have an increase in snow
days.

#### Days below freezing

Since snow depth data was fairly sparse I decided to also look at
temperature data. It would make sense that this would give me a larger
dataset since nearly all weather stations will include temperature
measurements. In particular, I looked at the number of days where the
*maximum* temperature in a county was below the freezing point (32F).
This would serve as a good indication of how many days during the year
have a potential for snow. [Here is the
dashboard](https://public.tableau.com/app/profile/ross.hjelle/viz/freezingdays/Dashboard1#1)
I created to look at the number of days below freezing each year. There
are no surprises here. Northern, interior, and mountain states all
tended to have more days below freezing.

Similar to with the snow data, I then looked at the trend in freezing
days over the years. This was done the same way as with the snow data
and the same caveats apply. [Here is the resulting
dashboard.](https://public.tableau.com/app/profile/ross.hjelle/viz/freezing_day_trend/Dashboard1)
There are some interesting things to observe here. An area from the
Northeast, through Ohio, Michigan, and parts of Indiana, Illinois, and
Wisconsin are all tending to see decrease in below freezing days. Much
of the Mountain West are also seeing a decrease in below freezing days.
Much of Minnesota, Montana, and northern Wisconsin are actually
experiencing an increase in below freezing days. Somewhat surprisingly,
parts of the south are also seeing an increase in below freezing days.

## Conclusions

Based on my analysis, The Upper Midwest (Minnesota, Wisconsin, North
Dakota) is the best bet for having, and continuing to have, good winters
for skiing. These states currently receive a large number of snowy days
and days below freezing. Large portions of these states also have either
positive or neutral trends in the number of snowy and freezing days.

New England currently receives good winters with lots of snowy and
freezing days. However, it also has a clear trend towards fewer days
below freezing. This could be an indication that white Christmases in
New England could soon be a thing of the past.

The Pacific Northwest currently receives less snow and freezing days
than the other areas I considered. This region also shows either
negative or neutral trends for snowy and freezing days. The caveat to
this conclusion is that this is a very mountainous area, which can
result in a high degree of local weather variations. It is possible the
county level aggregation is not sufficient to capture this variation.

One area I hadn’t considered, but maybe should be on my list is western
Montana (the Missoula area). This area currently sees fewer snowy and
freezing days than the Upper Midwest or New England. This area does have
a positive trend for the number of snowy days, and a neutral or slightly
positive trend in the number of days below freezing.