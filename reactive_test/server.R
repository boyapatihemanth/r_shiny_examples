server <- function(input, output, session) {
  data <- data.frame(date_val=character(0),acc_count=integer(0))
  getData <- reactive({
    corrStartDate <- input$fromto[1]
    corrEndDate <- input$fromto[2]
    theDate <- corrStartDate
    
    while (theDate <= corrEndDate)
    {
      strDate <- format(theDate, "%Y_%m_%d")
      csvFileName <- paste0("./data/aws_",strDate, "_data.csv")
      csvData <- read.csv(file=csvFileName, sep=',', header=TRUE)
      data[nrow(data) + 1, ] <- c(format(theDate, "%Y-%m-%d"),nrow(csvData))
      theDate <- theDate + 1              
    }
    data$acc_count <- as.integer(data$acc_count)
    data$date_val <- as.Date.numeric(data$date_val)
    return(data)
  })
  output$summary<- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(getData()$acc_count)
  })
  output$table <- renderTable({
    getData()
  })
}