
library(shiny)

# ui object
ui <- fluidPage(
  titlePanel(p("Dummy app", style = "color:#3474A7")),
  sidebarLayout(
    sidebarPanel(
      p("Made with", a("Shiny",
                       href = "http://shiny.rstudio.com"
      ), "."),
      img(
        src = "img.jpg",
        width = "70px", height = "70px"
      )
    ),
    mainPanel("main panel for outputs")
  )
)

# server()
server <- function(input, output) { }

# shinyApp()
shinyApp(ui = ui, server = server)
