fish <- read_csv("fish_for_r.csv")


fish %>% 
  filter(river = input$xxxxxx) %>% 
  filter(test_site = input$xxxxx) %>% 
  select(input$xxxxxx) %>% 
  ggplot() +
    aes(x = year, y = numerical_density_n_m2) +
    geom_col()



fish <- pivot_longer(fish, 4:7, names_to = "measurement_type", values_to = "result")


fish <- fish %>% 
  mutate(measurement_type = case_when(
    measurement_type == "numerical_density_n_m2" ~ "Numerical Density",
    measurement_type == "biomass_density_g_m2" ~ "Biomass Density",
    TRUE ~ measurement_type
  ))

write_csv(fish, "fish_for_r.csv")



fish %>% 
  filter(river == "Wick") %>% 
  filter(test_site == "Clow") %>% 
  filter(measurement_type == "Numerical Density") %>% 
  ggplot() +
  aes(x = year, y = measurment_type) +
  geom_col()



fish %>% 
  filter(river == "Thurso") %>% 
  summarise(unique(test_site))


plotly_fish <- fish %>% 
  filter(river == c"Thurso") %>% 
  filter(test_site == "Rumsdale") %>% 
  filter(measurement_type == "Numerical Density") %>% 
  ggplot() +
  aes(x = year, y = result) +
  geom_col()

ggplotly(plotly_fish)



plotly_fish <- fish %>% 
  filter(river_and_test_site %in% c("WICK Clow", "FORSS Cnoc-glas")) %>% 
  filter(measurement_type == "Numerical Density") %>% 
  ggplot() +
  aes(x = year, y = result) +
  labs(x = "\nYear",
       y = "Numerical Density") +
  scale_x_continuous(breaks = 2013:2021) +
  theme_minimal() +
  geom_col(aes(fill = river_and_test_site), position = "dodge")

ggplotly(plotly_fish)

fish <- fish %>% 
  mutate(river_and_test_site = str_to_upper(river)) %>% 
  mutate(test2 = test_site) %>% 
  unite(river_and_test_site, river_and_test_site, test2, sep = " ")


input <- list(river_and_test_site_input = "WICK Clow", density_input = "Numerical Density")


plotly_fish <- fish %>% 
  filter(river_and_test_site %in% input$river_and_test_site_input) %>% 
  filter(measurement_type == input$density_input) %>% 
  ggplot() +
  aes(x = year, y = result) +
  labs(x = "\nYear",
       y = input$density_input) +
  scale_x_continuous(breaks = 2013:2021) +
 # theme_minimal() +
  theme() +
  geom_col(aes(fill = river_and_test_site), position = "dodge") +
  scale_fill_manual(name = "", values = c("orange", "blue"))

ggplotly(plotly_fish)

