library(shiny)
library(DT)
require(RCurl)

dat <-read.csv(text=getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestData.csv"), header=T)

# Define UI for the app
ui <- navbarPage(
  title = 'PgenePapers (beta version):',
  tabPanel('Pseudogene-gene-role table',     DT::dataTableOutput('ex1')),
  tabPanel('All pepars',        DT::dataTableOutput('ex2')),
  tabPanel('Graph representation',      DT::dataTableOutput('ex3')),
  tabPanel('Readme',       DT::dataTableOutput('ex4'))
)

# Define server logic
function(input, output) {

  # display 10 rows initially
  output$ex1 <- DT::renderDataTable(
    DT::datatable(iris, options = list(pageLength = 25))
  )

  # -1 means no pagination; the 2nd element contains menu labels
  output$ex2 <- DT::renderDataTable(
    DT::datatable(
      iris, options = list(
        lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
        pageLength = 15
      )
    )
  )

  # you can also use paging = FALSE to disable pagination
  output$ex3 <- DT::renderDataTable(
    DT::datatable(iris, options = list(paging = FALSE))
  )

  # turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    DT::datatable(iris, options = list(searching = FALSE))
  )

  # write literal JS code in JS()
  output$ex5 <- DT::renderDataTable(DT::datatable(
    iris,
    options = list(rowCallback = DT::JS(
      'function(row, data) {
        // Bold cells for those >= 5 in the first column
        if (parseFloat(data[1]) >= 5.0)
          $("td:eq(1)", row).css("font-weight", "bold");
      }'
    ))
  ))
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
