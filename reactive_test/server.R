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
    data$date_val <- as.Date.character(data$date_val)
    data$acc_count <- as.integer(data$acc_count)
    return(data)
  })
  output$summary<- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(getData())
  })
  output$table <- renderTable({
    getData()
  })
  
  output$plot <- renderPlot({
    #plot(format(getData()$date_val, "%Y-%m-%d"), getData()$acc_count)
    ggplot( data = getData(), aes( date_val, acc_count )) + geom_line(colour='red') 
  }, res = 96)
  # output$plot <- renderPlot({
  #   ggplot(getData(),aes(x=getData()$date_val,y=getData()$acc_count))+geom_point(colour='red')},height = 400,width = 600)

}