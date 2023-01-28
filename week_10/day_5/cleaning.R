library(tidyverse)

white <- read_csv("raw_data/wine_quality_white.csv")

# Remove id column
white <- white %>% 
  select(-wine_id)

# Fix issues with pH 
# 3 clusters at 3, 3xx and 3xx
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

