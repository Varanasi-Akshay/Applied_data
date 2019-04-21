library(shiny)
library(rsconnect)

library(sp)
library(rgdal)
library(raster)
library(colorRamps)
library(rasterVis)
library(rgeos)

## data to keep with the app
county <- shapefile('US_COUNTY_SHPFILE/US_county_cont.shp')

ui <- pageWithSidebar(
  headerPanel('Plot a state'),
  sidebarPanel(
    selectInput('state', 'Select State', sort(unique(county$STATE_NAME))),
    selectInput('incl_county', 'Include counties?', c('Yes','No')),
    textInput('state_col','Color?','lightgray')
  ),
  mainPanel(
    plotOutput('plot1')
  )
)

server <- function(input, output, session) {
  
  # get the state name from the ui section and subset the county data to just that state
  state_data <- reactive({
    #print(input$state)
    if (input$incl_county == 'No') {
      
      s1 <- county[county$STATE_NAME == input$state,]
      gUnaryUnion(s1, id = s1@data$STATE_NAME)
      
    } 
    else { county[county$STATE_NAME == input$state,] }
  })
  
  
  output$plot1 <- renderPlot({
    plot(state_data(),col=input$state_col) ## for some reason, state_data needs a () after it
  })
  
}

shinyApp(ui, server)