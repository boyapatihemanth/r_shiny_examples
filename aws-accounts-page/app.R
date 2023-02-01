library(shiny)

ui <- fluidPage(
  dateInput("startDate", "Start Date"),
  dateInput("endDate", "End Date"),
  #dateRangeInput("holiday", "When do you want to go on vacation next?"),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(input, output, session) {
  #Create a reactive expression
  dataset <- reactive({
    # actually read the file
    read.csv(file='./data/aws_2023_01_21_data.csv', sep=',', header=TRUE)
  })
  
  data <- data.frame(date_val=character(0),acc_count=integer(0))
  new_data <- reactive({
    
    data[nrow(data) + 1, ] <- c('2023_01_21',nrow(dataset()))
    data[nrow(data) + 1, ] <- c('2023_01_21',nrow(dataset()))
    return(data)
  })
  
  output$summary <- renderPrint({
    # Use a reactive expression by calling it like a function
    nrow(dataset())
  })

  output$table <- renderTable({
    new_data()
  })
}
shinyApp(ui, server)