library(shiny)

shinyApp(
  shinyUI(
    navbarPage("My Application",
               tabPanel("Component 1", uiOutput('page1')),
               tabPanel("Component 2", uiOutput('page2')),
               tabPanel("Component 3")
    )
  ),
  shinyServer(function(input, output, session) {
    output$page1 <- renderUI({
      sidebarLayout(
        sidebarPanel(
          selectizeInput(
            'id', label = "Year", choices =   NULL,multiple=FALSE,selected="X2015",
            options = list(create = TRUE,placeholder = 'Choose the year')
          ),
          ## Make a list of checkboxes
          radioButtons("radio", label = h3("Radio buttons"),
                       choices = list("Choice 1" = 1, "Choice 2" = 2))
        ),
        mainPanel(
          plotOutput('distPlot')
        )
      )
    })
    
    output$distPlot <- renderPlot({ plot(1) })
    
    output$page2 <- renderUI({
      sidebarLayout(
        sidebarPanel(
          selectizeInput(
            'id', label = "Year", choices =   NULL,multiple=FALSE,selected="X2015",
            options = list(create = TRUE,placeholder = 'Choose the year')
          ),
          ## Make a list of checkboxes
          radioButtons("radio", label = h3("Radio buttons"),
                       choices = list("Choice one" = 1, "Choice two" = 2))
        ),
        mainPanel(
          plotOutput('distPlot2')
        )
      )
    })
    
    output$distPlot <- renderPlot({ plot(1) })
    output$distPlot2 <- renderPlot({ plot(2) })
  })
  
  
)
