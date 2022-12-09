library(shiny)
library(tidyverse)
library(bslib)
library(plotly)


fish <- read_csv("fish_for_r.csv")

fish <- fish %>% 
  filter(!river_and_test_site %in% c("THURSO Rangag", "THURSO Pipe Bridge", 
                                     "THURSO Tulach More", "THURSO Poll Chreagain"))


# removing test sites which have only 1 or 2 years of data



plot_colours <- c("#446e9b", "#999999", "#3cb521", "#d47500", "#cd0200", "#3399f3",
                  "#333333", "#6610f2", "yellow", "brown", "peachpuff", "#6f42c1",
                  "#e83e8c", "#fd7e14", "#20c997", "#000000", "grey50", "#eeeeee")

ui <- fluidPage(
  theme = bs_theme(bootswatch = 'spacelab'),
  titlePanel(tags$h1('Density of Salmon in Caithness Rivers')),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = 'density_input',
                   label = (tags$strong('Numerical or Biomass Density?')),
                   choices = c('Numerical Density', 'Biomass Density')),
      
      checkboxGroupInput(inputId = 'river_and_test_site_input',
                         label = (tags$strong("Select RIVER and Test Site")),
                         choices = unique(fish$river_and_test_site))
    ),
    
    mainPanel(
      plotlyOutput('fish_plot')
    )
  )
)  
  

server <- function(input, output) {
  output$fish_plot <- renderPlotly({
    plotly_fish <- fish %>% 
      filter(river_and_test_site %in% input$river_and_test_site_input) %>% 
      filter(measurement_type == input$density_input) %>% 
      ggplot() +
      aes(x = year, y = result) +
      labs(x = "\nYear",
           y = input$density_input) +
      scale_x_continuous(breaks = 2013:2021) +
      theme_minimal() +
      theme() +
      geom_col(aes(fill = river_and_test_site), position = "dodge") +
      scale_fill_manual(name = "", values = plot_colours)
    
    ggplotly(plotly_fish)
  })
  
  
}


shinyApp(ui = ui, server = server)


