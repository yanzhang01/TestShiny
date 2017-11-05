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
  dat <- read.delim("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/geneAndpseudogeneMappingRelations.txt", 
                    header = FALSE, sep = "|", check.names = FALSE, stringsAsFactors = FALSE)
  names(dat) <- c("Pseudogene ID", "Pseudogene Name", "Coding Gene ID", "Coding Gene Name", "Role")
  ref <- read.delim("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/codingGeneAndpseudoGeneMapping.txt", 
                    header = TRUE, sep = "|", check.names = FALSE, stringsAsFactors = FALSE)
  names(ref) <- c("Pseudogene Name", "Coding Gene Name", "PMID", "Abstract")
  
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
                      sort(unique(as.character(dat$"Pseudogene Name")))))
        ),
        column(4,
          selectInput("gene",
                      "Coding Gene:",
                    c("All",
                      sort(unique(as.character(dat$"Coding Gene Name")))))
        )
      ),
    
      # Create a new row for the graph
      fluidRow(
        simpleNetworkOutput('simple', width = "100%", height = "1000px")
      )
    )
  })
  
  output$simple <- renderSimpleNetwork({
    data <- dat
    if (input$pseudogene != "All") {
      data <- data[data$"Pseudogene Name" == input$pseudogene,]
    }
    if (input$gene != "All") {
      data <- data[data$"Coding Gene Name" == input$gene,]
    }
    if (nrow(data) > 0) {
      src <- data$"Pseudogene Name"
      target <- data$"Coding Gene Name" 
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
