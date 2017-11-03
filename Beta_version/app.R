library(shiny)
library(DT)
library(networkD3)
require(RCurl)

# Define UI for the app
ui <- navbarPage(
  title = 'PgenePapers (beta version):',
  tabPanel('Pseudogene-gene-role table', DT::dataTableOutput('ex1')),
  tabPanel('All papers', DT::dataTableOutput('ex2')),
  tabPanel('Graph representation', simpleNetworkOutput("simple")),
  tabPanel('About')
)

# Define server logic
server <- function(input, output) {
  
  # download data
  dat <- read.csv(text = getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestData.csv"), header = TRUE)
  ref <- read.csv(text = getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestPapers.csv"), header = TRUE)
  
  # Tab1
  output$ex1 <- DT::renderDataTable(
    DT::datatable(dat, options = list(pageLength = 25))
  )

  # Tab2
  output$ex2 <- DT::renderDataTable(
    DT::datatable(ref, options = list(pageLength = 25))
  )

  # Tab3
  output$simple <- renderSimpleNetwork({
    # Create fake data
    src <- c("A", "A", "A", "A",
             "B", "B", "C", "C", "D")
    target <- c("B", "C", "D", "J",
                "E", "F", "G", "H", "I")
    networkData <- data.frame(src, target)

    # Plot
    simpleNetwork(networkData)
  })

  # Tab4, use paging = FALSE to disable pagination, turn off filtering (no searching boxes)
  output$ex4 <- DT::renderDataTable(
    DT::datatable(dat, options = list(paging = FALSE, searching = FALSE))
  )
 
}

# Create Shiny app
shinyApp(ui = ui, server = server)
