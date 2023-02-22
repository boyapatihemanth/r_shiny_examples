library(shiny)
library(plotly)
ui <- fluidPage(
  
  verbatimTextOutput("summary"),
  tableOutput("table"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  # Create a reactive expression
  dataset <- reactive({
    # actually read the file
    op <- read.csv(file='./data.csv', sep=',', header=TRUE)
    pie_data <- data.frame("env"=colnames(op),"count"=c(op[,1 ],op[,2],op[,3]))
    print(pie_data)
  })
  
  output$summary <- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(dataset())
  })
  
  output$table <- renderTable({
    dataset()
  })
  
  USPersonalExpenditure <- data.frame("Categorie"=rownames(USPersonalExpenditure), USPersonalExpenditure)
  data <- USPersonalExpenditure[,c('Categorie', 'X1960')]
  
  fig <- plot_ly(data, labels = ~Categorie, values = ~X1960, type = 'pie')
  fig <- fig %>% layout(title = 'United States Personal Expenditures by Categories in 1960',
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  output$plot <- renderPlot({
    fig
  })
}
shinyApp(ui, server)