library(tidyverse)
library(plotly)

white <- read_csv("raw_data/wine_quality_white.csv")
red <- read_csv("raw_data/wine_quality_red.csv")

# Remove id column
white <- white %>% 
  select(-wine_id)

# Fix issues with pH 
# 3 clusters at 3, 3xx and 3xxx
# sorted by dividing values by 10 and 100 to give nice normal distribution 
# around 3.2ish

white <- white %>% 
  mutate(p_h = case_when(
    p_h > 100 ~ p_h / 100, 
    p_h > 10 ~ p_h / 10, 
    TRUE ~ p_h
  )) 


# Fix issues with alcohol, man what a hassle

white <- white %>% 
  mutate(alcohol = case_when(
    alcohol > 5e14 ~ alcohol / 1e14, 
    alcohol > 1e14 ~ alcohol / 1e13, 
    alcohol > 1000 ~ alcohol / 100,     
    alcohol > 500 ~ alcohol / 100, 
    alcohol > 100 ~ alcohol / 10,     
    alcohol > 50 ~ alcohol / 10, 
    TRUE ~ alcohol
  )) 


white %>% 
  ggplot(aes(fixed_acidity)) +
  geom_histogram()



# Binding the 2 decimal place quality column from data provided by CodeClan to the 
# dataset from the internet. 

whitered <- read_csv("raw_data/wine-quality-white-and-red.csv")

white_qual <- whitered %>% 
  filter(type == "white") %>% 
  bind_cols(white$quality, white$region) %>% 
  rename(quality2 = 14) %>% 
  rename(region = 15) %>% 
  select(-type)

# Checking the results make sense
p <- white_qual %>% 
  ggplot(aes(quality, decpoint2_qual)) +
  geom_point()

ggplotly(p)
# All data from x.5 to (x+1).5 has been added to a row containing (x+1) as the 
# quality rating. Sometimes the .5 data goes higher and lower but this doesn't 
# matter. 





write_csv(white_qual, "clean_data/white.csv")


# Repeating process with red dataset

red_qual <- whitered %>% 
  filter(type == "red") %>% 
  bind_cols(red$quality, red$region) %>% 
  rename(decpoint2_qual = 14)

p <- red_qual %>% 
  ggplot(aes(quality, decpoint2_qual)) +
  geom_point()

ggplotly(p)
# This hasn't worked so well and there is a lot more overlap
# For example for quality = 5, codeclan data ranges from 4.11 to 5.86
