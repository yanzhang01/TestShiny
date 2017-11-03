library(shiny)
library(DT)
library(networkD3)
library(markdown)
require(RCurl)

# Define UI for the app
ui <- navbarPage(
  title = 'PgenePapers (beta version):',
  tabPanel('Pseudogene-gene-role table', DT::dataTableOutput('ex1')),
  tabPanel('All papers', DT::dataTableOutput('ex2')),
  tabPanel('Graph presentation', uiOutput('graph_presentation')),
  #tabPanel('Graph presentation', simpleNetworkOutput('simple')),
  tabPanel('Readme', uiOutput('readme'))
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
  output$graph_presentation <- renderUI({  
    fluidPage(
      titlePanel("Select a pseudogene or gene:"),

      fluidRow(
        column(4,
          selectInput("pgene", 
                      "Pseudogene:",
                    c("All",
                      unique(as.character(dat$PgeneName))))
        ),
        column(4,
          selectInput("gene",
                      "Gene:",
                    c("All",
                      unique(as.character(dat$GeneName))))
        )
      ),
    
      # Create a new row for the table.
      fluidRow(
        #DT::dataTableOutput("table")
        src <- c("A", "A", "A", "A",
             "B", "B", "C", "C", "D")
    target <- c("B", "C", "D", "J",
                "E", "F", "G", "H", "I")
    networkData <- data.frame(src, target)
    # plot
    simpleNetwork(networkData)
      ) 
    )
  })
  
  #output$simple <- renderSimpleNetwork({
  #  # create fake data
  #  src <- c("A", "A", "A", "A",
  #           "B", "B", "C", "C", "D")
  #  target <- c("B", "C", "D", "J",
  #              "E", "F", "G", "H", "I")
  #  networkData <- data.frame(src, target)
  #  # plot
  #  simpleNetwork(networkData)
  #})

  # Tab4
  output$readme <- renderUI({  
    fluidRow(
      column(width = 8, offset = 1,
        includeMarkdown("README.md")
      )
    )
  })
  
}

# Create Shiny app
shinyApp(ui = ui, server = server)
