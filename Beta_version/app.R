library(shiny)
library(DT)
library(networkD3)
library(markdown)
require(RCurl)

# Define UI for the app
ui <- navbarPage(
  title = 'PgenePapers (beta version) Tools:',
  tabPanel('Pseudogene-gene-role table', DT::dataTableOutput('ex1')),
  tabPanel('All papers', DT::dataTableOutput('ex2')),
  tabPanel('Graph presentation', uiOutput('graph_presentation')),
  tabPanel('Readme', uiOutput('readme'))
)

# Define server logic
server <- function(input, output) {
  
  # Download data
  dat <- read.csv(text = getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestData.csv"), header = TRUE)
  #ref <- read.csv(text = getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestPapers.csv"), header = TRUE)
  ref <- read.delim(file = getURL("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/TestPapers.csv"), header = TRUE, 
                    sep = "|")
  
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
      titlePanel("Select one/all pseudogenes or genes:"),

      fluidRow(
        column(4,
          selectInput("pseudogene", 
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
    
      # Create a new row for the graph
      fluidRow(
        simpleNetworkOutput('simple')
      )
    )
  })
  
  output$simple <- renderSimpleNetwork({
    data <- dat
    if (input$pseudogene != "All") {
      data <- data[data$PgeneName == input$pseudogene,]
    }
    if (input$gene != "All") {
      data <- data[data$GeneName == input$gene,]
    }
    if (nrow(data) > 0) {
      src <- data$PgeneName
      target <- data$GeneName 
      networkData <- data.frame(src, target)
      # plot
      simpleNetwork(networkData)
    } 
  })

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
