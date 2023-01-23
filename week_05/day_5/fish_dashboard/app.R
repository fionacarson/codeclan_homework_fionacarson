# Using my own data rather than the games_sales data was approved by instructors. 


#library(shiny)
library(leaflet)
library(tidyverse)
library(readxl)
library(bslib)
library(plotly)

fish <- read_xlsx("fish_master.xlsx", sheet = "densities")

# Removing unrequired columns, cleaning data and pivoting longer

fish <- fish %>% 
  select(-(7:9), -(11:13)) %>% 
  janitor::clean_names() %>% 
  rename(river = catchment,
         test_site = location,
         numerical_density = numerical_density_n_m2_total, 
         biomass_density = biomass_density_g_m2_total,
         ph = p_h) %>% 
  pivot_longer(numerical_density:conductivity, 
               names_to = "measurement_type", 
               values_to = "result")

# Creating new column to allow river and test site to be selected together

fish <- fish %>% 
  mutate(location = str_to_upper(river), .after = test_site) %>% 
  mutate(location = str_c(location, test_site, sep = " "))

# Removing locations with only 1 or 2 years of data

fish <- fish %>% 
  filter(!location %in% c("THURSO Rangag", "THURSO Pipe Bridge", 
                          "THURSO Tulach More", "THURSO Poll Chreagain"))


plot_colours <- c("#446e9b", "#999999", "#3cb521", "#d47500", "#cd0200", "#3399f3",
                  "#333333", "#6610f2", "yellow", "brown", "peachpuff", "#6f42c1",
                  "#e83e8c", "#fd7e14", "#20c997", "#000000", "grey50", "#eeeeee")

# Apply correct y-axis label based on radio button choice
y_axis_labels <- c("Numerical Density (n/m<sup>2</sup>)",
                   "Biomass Density (g/m<sup>2</sup>)")
density_list <- c("numerical_density", "biomass_density")


ui <- fluidPage(
  theme = bs_theme(bootswatch = 'spacelab'),
  titlePanel(tags$h1('Density of Juvenile Salmon in Caithness Rivers')),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = 'density_input',
                   label = (tags$strong('Numerical or Biomass Density?')),
                   choices = list('Numerical Density' = 'numerical_density', 
                                  'Biomass Density' = 'biomass_density')),
      
      checkboxGroupInput(inputId = 'location_input',
                         label = (tags$strong("Select RIVER and Test Site")),
                         choices = unique(fish$location))
    ),
    
    mainPanel(
      
      # A bar graph was chosen to allow comparison of the salmon densities across time (years in this case). This gives information on current and future salmon stocks as well as the health of the river.
      # A widget was added to allow the user to compare the salmon densities of different locations. This is important and allows the user to identify which locations are doing well and which are having trouble with their salmon stocks. 
      
      plotlyOutput('fish_plot'),
      
      # A map was added to help visualise where the locations are in relation to each other. This could, for example, show if an issue is with a river system or a geographical area.       
      leafletOutput("map")
    )
  ),
  
  tags$a("Data source: Caithness District Salmon Fisheries Board, 
         Yearly Reports on Surveys of Juvenile Salmonids in Caithness Rivers.", 
         href = "https://caithness.dsfb.org.uk/publications/", "Provided under the terms of the Open Government Licence.")
)


server <- function(input, output) {
  
  output$fish_plot <- renderPlotly({
    
    plotly_fish <- fish %>% 
      # filtering location by check box input
      filter(location %in% input$location_input) %>% 
      # filtering density data (numerical or biomass) by radio button input
      filter(measurement_type == input$density_input) %>% 
      ggplot() +
      aes(x = year, y = result) +
      labs(x = "Year",
           y = y_axis_labels[which(density_list == input$density_input)]) +
      scale_x_continuous(limits = c(2012, 2022), breaks = 2013:2021) +
      theme_minimal() +
      theme() +
      geom_col(aes(fill = location), position = "dodge") +
      scale_fill_manual(name = "", values = plot_colours)
    
    ggplotly(plotly_fish)
  })
  
  output$map <- renderLeaflet({
    
    # Create map with small black circles at all locations    
    fish %>% 
      leaflet() %>% 
      addTiles() %>%
      addCircleMarkers(lat = ~latitude, 
                       lng = ~longitude, 
                       label = ~location,
                       #labelOptions = labelOptions(noHide = TRUE),
                       radius = 3, 
                       color = "black"
      )
    
  })
  
  # Create variable which contains locations selected by check box   
  fish_filtered <- reactive(
    fish[fish$location %in% input$location_input,])
  
  # Use fish_filtered variable above to update map and add markers at the locations selected by check box, while also keeping original black dots placed using code above.    
  observeEvent(input$location_input, {
    leafletProxy("map", data = fish_filtered()) %>%
      clearGroup("mygroup") %>%
      addMarkers(lat = ~latitude, 
                 lng = ~longitude, 
                 group = "mygroup")
  })
}

shinyApp(ui, server)
