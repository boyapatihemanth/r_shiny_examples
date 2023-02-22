library(shiny)
shinyApp(
shinyUI(
  navbarPage("My Application",
             tabPanel(
               "Component 1",
               sidebarLayout(
                 sidebarPanel(
                   selectizeInput(
                     'id', label="Year", choices=NULL, multiple=F, selected="X2015",
                     options = list(create = TRUE,placeholder = 'Choose the year')
                   ),
                   # Make a list of checkboxes
                   radioButtons("radio", label = h3("Radio buttons"),
                                choices = list("Choice 1" = 1, "Choice 2" = 2)
                   )
                 ),
                 mainPanel( plotOutput("distPlot") )
               )
             ),
             tabPanel("Component 2"),
             tabPanel("Component 3")
  )
)

shinyServer(function(input, output, session) {})
)