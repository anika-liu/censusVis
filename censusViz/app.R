

library(shiny)
library(shiny)

ui <- fluidPage(
  
  titlePanel("USA Census Visualization",
             windowTitle = "CnesusVis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 Census."),
      selectInput(inputId = "var",
                  label = "Choose a variable to display",
                  choices = list("Percent White", "Percent Black", "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"
      )
    ),
    mainPanel(
       textOutput(outputId = "selected_var"),
       plotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output) {
  
#  output$selected_var = renderText(
#    paste("You have selected: ", input$var)
#    )
  output$plot = renderPlot({
    
    counties <- reactive({
      
      race = readRDS("data/counties.rds")
      
      counties_map = map_data("county")
      View(counties_map)
      View(race)
      
      ## In order to join both tables, we need to make sure that we are combining them by 
      ## both state and county as a unique identifier.. so, we can combine region and
      ## subregion in the counties_map into a new variables called "name"
      
      counties_map = counties_map %>%
        mutate(name = paste(region, subregion, sep = ","))
      
      # Left join and right join
      
      left_join(counties_map, race, by = "name")
      # if the name is different: by = c("first variable","second variable")
    })
    
    race = switch(input$var,
                  "Percent White" = counties()$white,
                  "Percent Black" = counties()$black,
                  "Percent Hispanic" = counties()$hispanic,
                  "Percent Asian" = counties()$asian)
    
    ggplot(counties(), 
           aes(x = long, y = lat,
               group = group,
               fill = race)) +
      geom_polygon(color = "black") + 
      scale_fill_gradient(low = "white", high = "red")
  })
 }

shinyApp(ui, server)
