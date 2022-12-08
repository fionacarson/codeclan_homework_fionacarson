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
           selectInput(inputId = 'river_input',
                       label = (tags$strong('Select River')),
                       choices = fish$river)
    ),
    
    column(width = 3, offset = 1,
           uiOutput("secondSelection")
           ),
    
 #   column(width = 4, 
 #          selectInput(inputId = 'test_site_input',
  #                     label = (tags$strong('Select Test Site')),
 #                      choices = fish$test_site)
 #   ),
  
    column(width = 3, offset = 1,
           radioButtons(inputId = 'density_input',
                        label = (tags$strong('Numerical or Biomass Density?')),
                        choices = c('Numerical Density', 'Biomass Density'))
           ),
    
#    uiOutput("secondSelection")
    
    
    
  )
)
    
server <- function(input, output) {
  output$fish_plot <- renderPlotly({
    plotly_fish <- fish %>% 
      filter(river == input$river_input) %>% 
      filter(test_site == input$test_site_input) %>% 
      filter(measurement_type == input$density_input) %>% 
    ggplot() +
    aes(x = year, y = result) +
    labs(x = "\nYear",
         y = input$density_input) +
    scale_x_continuous(breaks = 2013:2021) +
    theme_minimal() +
    theme(
      
    ) +
    geom_col(fill = "#3399CC")
    
    ggplotly(plotly_fish)
    })
  
  output$secondSelection <- renderUI({
    selectInput(inputId = 'test_site_input',
                label = (tags$strong('Select Test Site')),
                choices = unique(fish[fish$river == input$river_input, "test_site"]))
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