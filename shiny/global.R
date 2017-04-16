library(dplyr)
library(tidyr)
library(readr)
library(tidyverse)
library(extracat)
raw_ntto_spend_y <- tbl_df(read.csv("./clean_data/clean_yearly_spending_region.csv", header = TRUE))
# raw_ntto_spend_m <- tbl_df(read.csv("./clean_data/Monthly_Exports_Imports_Balance.csv", header = TRUE))
raw_ntto_inbound_m <- tbl_df(read.csv("./clean_data/clean_monthly_visitation_inbound_country.csv", header = TRUE))
raw_ntto_outbound_m <- tbl_df(read.csv("./clean_data/clean_monthly_us_to_international.csv", header = TRUE))
raw_wb_gdp <- tbl_df(read.csv("./clean_data/API_NY.GDP.MKTP.CD_DS2_en_csv_v2.csv", header = TRUE, skip=4))



country_str <- 'Argentina|Australia|Brazil|Canada|Chile|China|Colombia|France|Germany|India|Italy|Japan|Mexico|Netherlands|Russia|Saudi Arabia|South Korea|Singapore|Spain|Sweden|Switzerland|Taiwan|United Kingdom|United States' 

tidy_ntto_spend_y <- raw_ntto_spend_y %>%
  gather(x_year, spend, -region, -type, -category) %>% 
  separate(x_year, c("X", "Year"), sep="X") %>% 
  select(-X) %>% 
  select(Region=region, Type=type, Category=category, Year=Year,Spend=spend) %>% 
  mutate(Missing = ifelse(is.na(Spend), "yes", "no"), Region=tolower(Region), Year=factor(Year), Region=factor(Region))

tidy_ntto_inbound_m <- raw_ntto_inbound_m %>%
  mutate(as.character(TOTAL.ARRIVALS)) %>% 
  gather(key, val, -year, -MONTH) %>%
  mutate(Arrival=as.numeric(gsub('[^0-9]+', '', val)), Month=match(tolower(substr(MONTH, 1, 3)), tolower(month.abb)), key=tolower(gsub('\\.', ' ', key)), Year=year) %>%
  filter(!grepl("total", key)) %>%
  unite(YearMonth, year, Month, sep="-") %>%
  select(Year, YearMonth, MixRegion=key, Inbound=Arrival) %>% 
  mutate(MixRegion=recode(MixRegion, 
                          "latin america  excl mexico "="latin america excl mexico",
                          "prc  excl hk "="china",
                          "roc  taiwan "="taiwan")) %>% 
  mutate(Missing = ifelse(is.na(Inbound), "yes", "no"), Year=factor(Year), Date=as.yearmon(YearMonth), MixRegion=factor(MixRegion)) %>% 
  arrange(MixRegion, Date)

tidy_ntto_outbound_m <- raw_ntto_outbound_m %>% 
  gather(Month, Outbound, -Year, -Regions) %>% 
  mutate(Outbound=as.numeric(gsub('[^0-9]+', '', Outbound)), Month=match(Month, month.abb), MixRegion=tolower(gsub('\\([a-zA-Z0-9]+\\)', '', Regions)), year=Year) %>% 
  mutate(MixRegion=gsub("^\\s+|\\s+$", "", MixRegion)) %>% 
  filter(!grepl("air", MixRegion), !MixRegion=='total overseas', !MixRegion=='north america', !MixRegion=='grand total') %>% 
  unite(YearMonth, year, Month, sep="-") %>% 
  mutate(Region=recode(MixRegion, 
                       "caribbean"="latin america excl mexico",
                       "central america"="latin america excl mexico",
                       "south america"="latin america excl mexico")) %>% 
  mutate(Missing=ifelse(is.na(Outbound), "yes", "no"), Year=factor(Year), Date=as.yearmon(YearMonth), MixRegion=factor(MixRegion), Region=factor(Region)) %>% 
  select(Region, MixRegion, Year, Date, Missing, Outbound) %>% 
  arrange(Region, MixRegion, Date)


tidy_wb_gdp <- raw_wb_gdp %>% 
  select(-Indicator.Name, -Indicator.Code, -X) %>% 
  gather(x_year, GDP, -Country.Name, -Country.Code) %>% 
  filter(grepl(country_str, Country.Name)) %>% 
  separate(x_year, c("X", "Year"), sep="X") %>% 
  select(-X) %>% 
  select(CountryName=Country.Name, CountryCode=Country.Code, Year=Year, GDP=GDP) %>% 
  # filter(year>1999) %>% 
  mutate(Missing = ifelse(is.na(GDP), "yes", "no"))




region_str <- "africa|asia|canada|latin america (excl mexico)|europe|mexico|middle east|oceania"

inbound_region <- tidy_ntto_inbound_m %>% 
  filter(grepl(region_str, MixRegion)) %>% 
  select(Region=MixRegion, Year, Date, Inbound) %>% 
  group_by(Region, Year, Date) %>% 
  summarise(numbercount=sum(Inbound))

outbound_region <- tidy_ntto_outbound_m %>% 
  select(Region, Year, Date, Outbound) %>% 
  group_by(Region, Year, Date) %>% 
  summarise(numbercount=sum(Outbound))

regional_travel <- inner_join(inbound_region, outbound_region, 
                              by=c("Region"="Region", "Year"="Year", "Date"="Date"))

tidy_ntto_inbound_y <- tidy_ntto_inbound_m %>% 
  group_by(Year, MixRegion) %>% 
  summarise(numbercount=sum(Inbound))

tidy_ntto_outbound_y <- tidy_ntto_outbound_m %>% 
  group_by(Year, MixRegion) %>% 
  summarise(numbercount=sum(Outbound))