library(shiny)
library(DT)
require(RCurl)

# Define UI for the app
ui <- navbarPage(
  title = 'PgenePapers (beta version):',
  tabPanel('Pseudogene-gene-role table',     DT::dataTableOutput('ex1')),
  tabPanel('All papers',        DT::dataTableOutput('ex2')),
  tabPanel('Graph representation',      DT::dataTableOutput('ex3')),
  tabPanel('Readme',       DT::dataTableOutput('ex4'))
)

# Define server logic
server <- function(input, output) {
  
  # download data
  dat <- read.csv(text=getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestData.csv"), header=TRUE)
  ref <- read.csv(text=getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestPapers.csv"), header=TRUE)
  
  # Tab1
  output$ex1 <- DT::renderDataTable(
    DT::datatable(dat, options = list(pageLength = 25))
  )

  # Tab2
  output$ex2 <- DT::renderDataTable(
    DT::datatable(ref, options = list(pageLength = 25))
  )

  # Tab3 you can also use paging = FALSE to disable pagination
  output$ex3 <- DT::renderDataTable(
    DT::datatable(dat, options = list(paging = FALSE))
  )

  # Tab4 turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    DT::datatable(dat, options = list(searching = FALSE))
  )
 
}




#server <- function(input, output, session) {
#
#  # Combine the selected variables into a new data frame
#  selectedData <- reactive({
#    iris[, c(input$xcol, input$ycol)]
#  })
#
#  clusters <- reactive({
#    kmeans(selectedData(), input$clusters)
#  })
#
#  output$plot1 <- renderPlot({
#    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
#      "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
#
#    par(mar = c(5.1, 4.1, 0, 1))
#    plot(selectedData(),
#         col = clusters()$cluster,
#         pch = 20, cex = 3)
#    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
#  })
#
#}

# Create Shiny App
shinyApp(ui = ui, server = server)
