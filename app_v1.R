library(ggplot2)
shiny_output <- readRDS("my_plot.rds")
#columns_desired_for_output <- c("phenotype","description","group","beta","SE","OR","p","n_total","n_cases","direction","size") # good for full phewas data
columns_desired_for_output <- c("phenotype","description","group","p") # good for interaction term data

###################################

ui <- fluidPage(
  fluidRow(
    column(width = 12,
           plotOutput("plot1", height = 600,
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           )
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

server <- function(input, output) {
  output$plot1 <- renderPlot({
    shiny_output
  })
  
  columns = columns_desired_for_output
  
  output$click_info <- DT::renderDataTable(DT::datatable({
    nearPoints(shiny_output$data, input$plot1_click, addDist = F)[,columns]
  }))
  
  output$brush_info <- DT::renderDataTable(DT::datatable({
    brushedPoints(shiny_output$data, input$plot1_brush)[,columns]
  }))
}

###################################

shinyApp(ui, server)
