library(shiny)

# Define UI for slider demo app ----
ui <- fluidPage(
  titlePanel("submitButton example"),
  fluidRow(
    column(3, wellPanel(
      sliderInput("n", "N:", min = 10, max = 1000, value = 200,
                  step = 10),
      textInput("text", "Text:", "text here"),
      submitButton("Submit")
    )),
    column(6,
           plotOutput("plot1", width = 400, height = 300),
           verbatimTextOutput("text")
    )
  )
)

# Define server logic for slider examples ----
server <- function(input, output) {
  output$plot1 <- renderPlot({
    hist(rnorm(input$n))
  })
  
  output$text <- renderText({
    paste("Input text is:", input$text)
  })
}

# Create Shiny app ----
shinyApp(ui, server)