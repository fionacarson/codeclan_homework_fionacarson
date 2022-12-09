library(shiny)
library(tidyverse)
library(bslib)
library(plotly)


fish <- read_csv("fish_for_r.csv")


ui <- fluidPage(
  theme = bs_theme(bootswatch = 'yeti'),
  titlePanel(tags$h1('Density of Salmon in Caithness Rivers')),
  
  fluidRow(
    plotlyOutput('fish_plot')
  ),
  
  fluidRow(
    column(width = 3, offset = 1,
          checkboxGroupInput(inputId = 'river_and_test_site_input',
                       label = "Select River and Test Site",
                       choices = unique(fish$river_and_test_site))
    ),

    
    column(width = 3, offset = 1,
           radioButtons(inputId = 'density_input',
                        label = 'Numerical or Biomass Density?',
                        choices = c('Numerical Density', 'Biomass Density'))
    ),
  
  )
) 

#<button type="button" class="btn btn-primary">Default button</button>

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
      geom_col(aes(fill = river_and_test_site), position = "dodge")
    
    ggplotly(plotly_fish)
  })
  
  
}


shinyApp(ui = ui, server = server)




#tableOutput("tb_chosen")

#output$tb_chosen <- renderTable(subset(fish,
#                                      fish$river==input$river_input
#                                     & fish$test_site==input$test_site_input), 
#                             rownames=TRUE)

# observe function which updates the second selectInput when the 
#  first selectInput is changed
#observe({ updateSelectInput(session,
#                           inputId="test_site_input", choices=unique(fish
#                                                                      [fish$river == input$river_input,"items"])
#)
#})    
#}

#paste(input$test_site, " on ", input$river, "river"),