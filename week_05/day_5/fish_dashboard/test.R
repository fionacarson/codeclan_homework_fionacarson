library(shiny)
library(leaflet)

# c("Monday","Tuesday","Wednesday", "Thursday", "Friday","Saturday","Sunday")

mydata <- data.frame(occurrencedayofweek = c(1:7),
                     longitude = c(10.47, 10.48, 10.49, 10.50,10.51, 10.52, 10.53),
                     latitude = c(45.76, 45.77, 45.78, 45.79, 45.80, 45.81, 45.82))

shinyApp(
  
  ui <- fluidPage(
    
    leafletOutput ("map"),
    
    checkboxGroupInput("checkGroup", "Week Day",
                       choices = c("Monday" = 1,
                                   "Tuesday" = 2,
                                   "Wednesday" = 3,
                                   "Thursday" = 4,
                                   "Friday" = 5,
                                   "Saturday" = 6,
                                   "Sunday" = 7),
                       selected = 1)
  ),
  
  server <- function(input, output, session){
    
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        addMarkers(data = mydata,
                   ~longitude,
                   ~latitude,
                   group = "mygroup")
    })
    
    mydata_filtered <- reactive(mydata[mydata$occurrencedayofweek %in% input$checkGroup, ])
    
    observeEvent(input$checkGroup, {
      leafletProxy("map", data = mydata_filtered()) %>%
        clearGroup ("mygroup") %>%
        addMarkers(lng =  ~longitude,
                   lat = ~latitude,
                   group = "mygroup")
    })
    
  }
  
)