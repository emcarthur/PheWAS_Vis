#!/usr/bin/Rscript

# runPheWAS_vis.R
# R script to make interactive PheWAS plots using Shiny
# Follow changes at https://github.com/emcarthur/PheWAS_vis
# Evonne McArthur 2/2018

# Input: Takes output ggplot file from PheWAS
#	To generate this file save the output PheWAS 
#	RData ggplot with saveRDS(my_plot,"my_plot.rds") 
# Output: Interactive shiny plot
#	To load anywhere (make sure shiny is installed as library): 
#	runGitHub("PheWAS_vis", "emcarthur")

# Variables to run 'runPheWAS_vis':
#   plotObjectOutputFromPhewas = the ggplot object output from PheWAS
#   directionality = T/F: True means you want the ability to toggle data points based on direction of association
#   columnsInOutTable = array of column names or NULL: these are the columns in the table that will be output
#     when interacting with the plot. A good default column array = c("phenotype","description","group","beta","SE","OR","p","n_total","n_cases","direction","size")
#   heightOfPlot = num: the height in pixels you want the plot to be
#   heightOfWindow = num or NULL: the height of the html window object to hold all the data, keep as NULL unless you are using with an Rmd file

# Sample Usage
# plotObjectOutputFromPhewas <- readRDS("my_plot.rds")
# runPheWAS_vis(plotObjectOutputFromPhewas, directionality = TRUE, columnsInOutTable = c("phenotype","description","group","beta","SE","OR","p","n_total","n_cases","direction","size"))

runPheWAS_vis <- function(plotObjectOutputFromPhewas, directionality = FALSE, columnsInOutTable = NULL, heightOfPlot = 600, heightOfWindow = NULL) {
  
  # read in necessary dependencies
  library(ggplot2)
  library(shiny)
  
  # set columns to approrpiate array
  if (is.null(columnsInOutTable)) {
    columns = colnames(plotObjectOutputFromPhewas$data)
  } else {
    columns = columnsInOutTable
  }
  
  ###################################
  
  ui <- fluidPage(
    fluidRow(
      # Plot
      column(width = 10,
             plotOutput("plot1", height = heightOfPlot,
                        click = "plot1_click",
                        brush = brushOpts(
                          id = "plot1_brush"
                        )
             )
      ),
      # Radio buttons for the direction of association
      column(width = 2,
             if (directionality) {
               wellPanel(radioButtons("input_direction", "Association direction:", 
                                      choices <- names(table(data.frame(c("Both","+","-")))),selected="Both"))
             }
      )
    ),
    # Table info for clicks and highlighted points
    fluidRow(
      column(width = 12,
             h4("Points near click"),
             DT::dataTableOutput("click_info")
      ),
      column(width = 12,
             h4("Highlighted points"),
             DT::dataTableOutput("brush_info")
      )
    )
  )
  
  ###################################
  
  server <- function(input, output) {
    # plot if no directionality
    if (!directionality) {
      output$plot1 <- renderPlot({
        plotObjectOutputFromPhewas
      })
    } else {
      # plot if directionality = TRUE
      output$plot1 <- renderPlot({
        in_dir <- NA
        
        # interpreting input from +,-, or both associations and producing appropriate plot object
        if( input$input_direction != "Both" ) {
          
          if( input$input_direction == "+" ) {
            in_dir <- "TRUE"
            # change plot symbols to up-pointing triangles:
            plotObjectOutputFromPhewas <- plotObjectOutputFromPhewas + scale_shape_manual(values = c(24,25))
            
          } else {
            in_dir <- "FALSE"
          }
          plotObjectOutputFromPhewas$data <- plotObjectOutputFromPhewas$data[which(as.character(plotObjectOutputFromPhewas$data$direction) == as.character(in_dir)),]
          
        }
        # plot!
        plotObjectOutputFromPhewas
      })
    }
    
    
    output$click_info <- DT::renderDataTable(DT::datatable({
      nearPoints(plotObjectOutputFromPhewas$data, input$plot1_click, addDist = F)[,columns]
    }))
    
    output$brush_info <- DT::renderDataTable(DT::datatable({
      brushedPoints(plotObjectOutputFromPhewas$data, input$plot1_brush)[,columns]
    }))
  }
  
  ###################################
  
  # run the app here, edit this if using in a R markdown file with comment below
  
  
  if (is.null(heightOfWindow)) {
    shinyApp(ui, server)
  } else {
    shinyApp(ui, server, options = list(height = heightOfWindow))
  }
  
}



