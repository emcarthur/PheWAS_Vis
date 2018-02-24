#!/usr/bin/Rscript

# PheWAS_vis.R
# R script to make interactive PheWAS plots using Shiny
# Follow changes at https://github.com/emcarthur/PheWAS_vis
# Evonne McArthur 2/2018

# Input: Takes output ggplot file from PheWAS
#	To generate this file save the output PheWAS 
#	RData ggplot with saveRDS(my_plot,"my_plot.rds") 
# Output: Interactive shiny plot
#	To load anywhere (make sure shiny is installed as library): 
#	runGitHub("PheWAS_vis", "emcarthur")

library(ggplot2)
library(shiny)
# read in your PheWAS output here:
shiny_output <- readRDS("my_plot.rds")

###################################

ui <- fluidPage(
  fluidRow(
    column(width = 10,
           plotOutput("plot1", height = 600,
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           )
    ),
    # radio buttons for the direction of association
    column(width = 2,
           wellPanel(radioButtons("input_direction", "Association direction:", 
                                  choices <- names(table(data.frame(c("Both","+","-")))),selected="Both"))
    )
  ),
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
  input <- input
  output <- output
  output$plot1 <- renderPlot({
    in_dir <- NA
    
    if( input$input_direction != "Both" ) {
      
      if( input$input_direction == "+" ) {
        in_dir <- "TRUE"
	# change plot symbols to up-pointing triangles:
        shiny_output <- shiny_output + scale_shape_manual(values = c(24,25))
        
      } else {
        in_dir <- "FALSE"
      }
      shiny_output$data <- shiny_output$data <- shiny_output$data[which(as.character(shiny_output$data$direction) == as.character(in_dir)),]
      
    }
    shiny_output
  })
  
  columns = c("phenotype","description","group","beta","SE","OR","p","n_total","n_cases","direction","size")
  
  output$click_info <- DT::renderDataTable(DT::datatable({
    nearPoints(shiny_output$data, input$plot1_click, addDist = F)[,columns]
  }))
  
  output$brush_info <- DT::renderDataTable(DT::datatable({
    brushedPoints(shiny_output$data, input$plot1_brush)[,columns]
  }))
}

###################################

# run the app here, edit this if using in a R markdown file with comment below
shinyApp(ui, server)
#shinyApp(ui, server, options = list(height = 2000))


