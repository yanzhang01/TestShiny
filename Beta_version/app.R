library(shiny)
library(DT)
library(networkD3)
library(markdown)
require(RCurl)

# Define UI for the app
ui <- navbarPage(
  title = 'PgenePapers (beta version) Tools:',
  tabPanel('Pseudogene-Gene-Role Table', DT::dataTableOutput('ex1')),
  tabPanel('All Papers', DT::dataTableOutput('ex2')),
  tabPanel('Graph Presentation and Data Download', uiOutput('graph_presentation')),
  tabPanel('Readme', uiOutput('readme'))
)

# Define server logic
server <- function(input, output) {
  
  # Download and format data
  dat <- read.delim("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/geneAndpseudogeneMappingRelations.txt", 
                    header = FALSE, sep = "|", check.names = FALSE, stringsAsFactors = FALSE)
  dat.2 <- apply(dat, 2, function(x) gsub("^\\s+", "", x))
  dat.3 <- apply(dat.2, 2, function(x) gsub("\\s+$", "", x))
  dat <- data.frame(dat.3, stringsAsFactors = FALSE)
  names(dat) <- c("Pseudogene ID", "Pseudogene Name", "Coding Gene ID", "Coding Gene Name", "Role")
  rm(dat.2)
  rm(dat.3)
  #dat <- dat[order(dat$"Pseudogene Name", dat$"Role"),]
              
  ref <- read.delim("https://raw.githubusercontent.com/yanzhang01/shiny_PgenePapers/master/Beta_version/codingGeneAndpseudoGeneMapping.txt", 
                    header = TRUE, sep = "|", check.names = FALSE, stringsAsFactors = FALSE)
  ref.2 <- apply(ref, 2, function(x) gsub("^\\s+", "", x))
  ref.3 <- apply(ref.2, 2, function(x) gsub("\\s+$", "", x))
  ref <- data.frame(ref.3, stringsAsFactors = FALSE)
  names(ref) <- c("Pseudogene Name", "Coding Gene Name", "PMID", "Abstract")
  rm(ref.2)
  rm(ref.3)
  #ref <- ref[order(ref$"PMID"),]
                 
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
        ),
        column(4,
          selectInput("display_width",
                      "Select the width of graph display:",
                    c("100%", "150%", "200%"))
        )
      ),
    
      # Creat a button to save network data
      fluidRow(
        column(12, "Click the button to", downloadButton("downloadData", "Download filtered data"), 
               ". You can also right click on your mouse and print the graph into a PDF file.")
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
      data <- data[data$"Pseudogene Name" == input$pseudogene,]
    }
    if (input$gene != "All") {
      data <- data[data$"Coding Gene Name" == input$gene,]
    }
    if ((input$pseudogene == "All") && (input$gene == "All")) {
      src <- data$"Pseudogene Name"
      target <- data$"Coding Gene Name" 
      networkData <- data.frame(src, target)
      # plot
      simpleNetwork(networkData, fontSize = 10, width = "200%", height = "1400px")
    } else if (nrow(data) > 0) {
      src <- data$"Pseudogene Name"
      target <- data$"Coding Gene Name" 
      networkData <- data.frame(src, target)
      # plot
      simpleNetwork(networkData, fontSize = 10, width = "100%")
    }
  })
  
  # Download csv of filtered data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$pseudogene, "_", input$gene, ".csv", sep = "")
    },
    content = function(file) {
      data <- dat
      if (input$pseudogene != "All") {
        data <- data[data$"Pseudogene Name" == input$pseudogene,]
      }
      if (input$gene != "All") {
        data <- data[data$"Coding Gene Name" == input$gene,]
      }
      write.csv(data, file, row.names = FALSE)
    }
  )

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
