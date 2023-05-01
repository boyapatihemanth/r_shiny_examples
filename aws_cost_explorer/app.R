#library(brochure)
library(paws)
library(plotly)

readRenviron(".Renviron")
svc_ce <- costexplorer(
  config = list(
    credentials = list(
      creds = list(
        access_key_id = Sys.getenv('aws_access_key_id'),
        secret_access_key = Sys.getenv('aws_secret_access_key')
      )
    ),
    region = "us-east-1"
  )
)


ui <- fluidPage(
  dateRangeInput("fromto", "From and To", start = '2023-01-01', end = '2023-01-03', min = '2023-01-01',
                     max = '2023-04-26'),
  verbatimTextOutput("summary"),
  selectInput("metric", "Select Metric", choices = c("UnblendedCost", "BlendedCost", "AmortizedCost" , "NetAmortizedCost" , "NetUnblendedCost" , "NormalizedUsageAmount")),
  plotlyOutput("plot")
)
populate_data_table <- function(item, data_output, counter, metric) {
    data_output[nrow(data_output) + 1, ] <- c(item$ResultsByTime[[counter]]$TimePeriod$End,
                                              eval(parse(text=(paste0("item$ResultsByTime[[",counter,"]]$Total$",metric,"$Amount")))))
  
  return(data_output)
}
current_data <- function(item, number_of_days, metric) {
  data_output <- data.frame(date=character(0),
                            cost=numeric(0))
  for(x in 1:number_of_days) {
    data_output <- populate_data_table(item = item, data_output = data_output, counter = x, metric = metric)
  }
  return(data_output)
  
}

server <- function(input, output, session) {
  dataset <- reactive({
    DataStartDate <- input$fromto[1]
    DataEndDate <- input$fromto[2]
    metric <- input$metric
    date_1 = as.Date(DataStartDate)
    date_2 = as.Date(DataEndDate)
    number_of_days <- as.numeric(difftime(date_2,date_1, units = "days"))
    item <- svc_ce$get_cost_and_usage(
        TimePeriod = list(
            Start = DataStartDate,
            End = DataEndDate
        ),
        Granularity = "DAILY",
        Metrics = metric
    )
    #print(item)
    data <- current_data(item = item, number_of_days = number_of_days, metric = metric)
    return(data)
  })
  output$summary <- renderPrint({
    dataset()
  })
  output$plot <- renderPlotly({
    plotly_data <- dataset()
    
    # fig <- plot_ly(plotly_data, lables = ~date, values = ~cost, type = pie)
    # fig <- fig %>% layout(title = "Price",
    #                       xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    #                       yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    fig <- plot_ly(
      x = c(plotly_data$date),
      y = c(plotly_data$cost),
      name = "AWS Cost",
      type = "bar"
    )
    fig
  })
}

shinyApp(ui, server)