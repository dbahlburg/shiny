library(maps)
library(mapproj)
library(shiny)
source("census_app/helpers.R")
counties <- readRDS("census_app/data/counties.rds")

# Define UI ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
            helpText("Create demographic maps with",
                     'information from the 2010 US Census.'),
            selectInput("var", h4("Choose a variable to display"), 
                       choices = list("Percent White",
                                      "Percent Black",
                                      "Percent Hispanic",
                                      "Percent Asian"), selected = 'Percent Black'),
            sliderInput("slider1", h3("Range of interest:"),
                       min = 0, max = 100, value = c(0,100))
     ),
    mainPanel(#textOutput("selected_var"),
              #textOutput('selected_range'),
              plotOutput('map')
              )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  #output$selected_var <- renderText({ 
  # paste("You have selected:",input$var)})
  
  #output$selected_range <- renderText({ 
  # paste('You have chosen a range that goes from ', input$slider1[1],'to',input$slider1[2])})
   
   output$map <- renderPlot({
     data <- switch(input$var,
                    "Percent White" = counties$white,
                    "Percent Black" = counties$black,
                    "Percent Hispanic" = counties$hispanic,
                    "Percent Asian" = counties$asian)
     percent_map(var = data,color = "darkgreen", legend.title = paste(input$var), input$slider1[1], input$slider1[2])
   })
}

# Run the app ----
shinyApp(ui = ui, server = server)
