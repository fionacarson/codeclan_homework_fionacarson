library(shiny)
library(leaflet)
library(tidyverse)




ui <- fluidPage(
  selectInput("region", "Which Region?", unique(whisky$Region)),
  leafletOutput("map")
)






server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    whisky %>% 
      filter(Region == input$region) %>%
      leaflet() %>% 
      addTiles() %>%
      addCircleMarkers(lat = ~Latitude, lng = ~Longitude, popup = ~Distillery)
    
  })
}

shinyApp(ui, server)
