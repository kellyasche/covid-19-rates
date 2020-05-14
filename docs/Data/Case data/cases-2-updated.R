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


# Prep cases-2 ------------------------------------------------------------

data <- read_csv("Data/Case data/cases-2.csv")

cases.1 <- data %>%
  select(1:4) %>%
  right_join(counties.regions, by = c("County" = "Name")) %>%
  fill(Date)

cases.2 <- data %>%
  select(5:8) %>%
  right_join(counties.regions, by = c("County_1" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.3 <- data %>%
  select(9:12) %>%
  right_join(counties.regions, by = c("County_2" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.4 <- data %>%
  select(13:16) %>%
  right_join(counties.regions, by = c("County_3" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.5 <- data %>%
  select(17:20) %>%
  right_join(counties.regions, by = c("County_4" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.6 <- data %>%
  select(21:24) %>%
  right_join(counties.regions, by = c("County_5" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.7 <- data %>%
  select(25:28) %>%
  right_join(counties.regions, by = c("County_6" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.8 <- data %>%
  select(29:32) %>%
  right_join(counties.regions, by = c("County_7" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.9 <- data %>%
  select(33:36) %>%
  right_join(counties.regions, by = c("County_8" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.10 <- data %>%
  select(37:40) %>%
  right_join(counties.regions, by = c("County_9" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)

cases.11 <- data %>%
  select(41:44) %>%
  right_join(counties.regions, by = c("County_10" = "Name")) %>%
  rename("County" = 1,
         "Date" = 2,
         "Cases" = 3,
         "Deaths" = 4) %>%
  fill(Date)


# Combine cases -----------------------------------------------------------

master.data <- cases.1 %>%
  rbind(cases.2, cases.3, cases.4, cases.5, cases.6, cases.7, cases.8, cases.9, cases.10, cases.11) %>%
  filter(County != "Minnesota")

write_csv(master.data, "Data/Case data/cases-2-updated.csv")


names(master.data)
