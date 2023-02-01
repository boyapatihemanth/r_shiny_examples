library(shiny)
library(ggplot2)
ui <- fluidPage(
  titlePanel("Account Details"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("fromto", "From and To", start = '2023-01-21', end = '2023-01-26', min = '2023-01-21',
                     max = '2023-01-26')
    ),
    mainPanel(
      verbatimTextOutput("summary"),
      tableOutput("table"),
      plotOutput("plot")
    )
  )
)