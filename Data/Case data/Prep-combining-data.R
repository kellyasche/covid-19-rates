library(tidyverse)

counties.regions <- read_csv("Data/Join docs/county_regions.csv") %>%
  mutate(countyfp = formatC(countyfp, width = 3, flag = "0"),
         Name = str_to_title(Name),
         Name = str_replace(Name, "Q", "q"),
         Name = str_replace(Name, "Of The", "of the"),
         Name = str_replace(Name, "Mcleod", "McLeod"),
         Dem_Desc = ifelse(Name == "Minnesota", "Minnesota", Dem_Desc) ,
         edr = str_replace(edr, "  ", " "),
         planning.region = str_replace(planning.region, " Minnesota", ""),
         planning.region = fct_relevel(planning.region, "Northwest", "Northeast", "Central", "Seven County Mpls-St Paul", "Southwest", "Southeast"),
         edr = fct_relevel(edr, "EDR 1 - Northwest", "EDR 2 - Headwaters", "EDR 3 - Arrowhead", "EDR 4 - West Central", "EDR 5 - North Central", "EDR 6E- Southwest Central", "EDR 6W- Upper Minnesota Valley", "EDR 7E- East Central", "EDR 7W- Central", "EDR 8 - Southwest", "EDR 9 - South Central", "EDR 10 - Southeast", "EDR 11 - 7 County Twin Cities", "Minnesota"))


# Import and prep objects -------------------------------------------------

data.1 <- read_csv("Data/Case data/cases-1-updated.csv") %>%
  mutate(County = str_replace(County, " County, Minnesota", "")) %>%
  left_join(counties.regions, by = c("County" = "Name"))

total.pop <- data.1 %>%
  select(2,5) %>%
  group_by(countyfp) %>%
  distinct(total.pop) %>%
  ungroup()

data.1.1 <- data.1 %>%
  select(1, 3:9) %>%
  mutate(Deaths = NA)

data.2 <- read_csv("Data/Case data/cases-2-updated.csv") %>%
  rbind(data.1.1) 


# Import newest data ------------------------------------------------------

data.3 <- read_csv("Data/Case data/cases-2020-05-13.csv") %>%
  mutate(Date = "5/13/2020") %>%
  right_join(counties.regions, by = c("County" = "Name")) %>%
  fill(Date)

data.4 <- read_csv("Data/Case data/cases-2020-05-14.csv") %>%
  mutate(County = iconv(County, "UTF-8", "UTF-8",sub=''),
         Deaths = iconv(Deaths, "UTF-8", "UTF-8", sub = "")) %>%
  right_join(counties.regions, by = c("County" = "Name")) %>%
  fill(Date)

data.5 <- read_csv("Data/Case data/cases-2020-05-15-and-2020-05-16.csv") %>%
  mutate(County = iconv(County, "UTF-8", "UTF-8",sub=''),
         Deaths = iconv(Deaths, "UTF-8", "UTF-8", sub = "")) %>%
  right_join(counties.regions, by = c("County" = "Name")) %>%
  fill(Date)

data.6 <- read_csv("Data/Case data/cases-2020-05-17.csv") %>%
  mutate(County = iconv(County, "UTF-8", "UTF-8",sub=''),
         Deaths = iconv(Deaths, "UTF-8", "UTF-8", sub = "")) %>%
  right_join(counties.regions, by = c("County" = "Name")) %>%
  fill(Date)

data.7 <- read_csv("Data/Case data/cases-2020-05-18-through-21.csv") %>%
  mutate(County = iconv(County, "UTF-8", "UTF-8",sub=''),
         Deaths = iconv(Deaths, "UTF-8", "UTF-8", sub = "")) %>%
  right_join(counties.regions, by = c("County" = "Name")) %>%
  fill(Date)

# Combine all data --------------------------------------------------------

master.data <- data.2 %>%
  rbind(data.3,data.4, data.5, data.6, data.7) %>%
  left_join(total.pop, by = "countyfp") 

write_csv(master.data, "Data/Case data/Master-cases-county.csv")

names(data.3)
names(data.2)
