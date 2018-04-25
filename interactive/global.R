library(dplyr)

allzips <- readRDS("data/map_data.Rds")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$zipcode <- formatC(allzips$zip, width=5, format="d", flag="0")

cleantable <- allzips %>%
  select(
    City = city,
    State = state,
    Zipcode = zip,
    Party = party,
    Type = type,
    Occupation = occupation,
    Amount = amount,
    Lat = latitude,
    Long = longitude,
    Date = date,
    Month = month
  )
