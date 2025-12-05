library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(bslib)
library(thematic)
library(plotly)

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "minty"
  ),
    titlePanel("Exploration des diamonds"),
    
    sidebarLayout(
        sidebarPanel(
          
          radioButtons(inputId = "radio", 
                       label = "Colorié les points en rose ?",
                       choices = list("Oui"=1, "Non"=2),
                       selected = 1),
          
            sliderInput(inputId = "prix",
                        label = "Prix maximum",
                        min = 300,
                        max = 20000,
                        value = 5000),
          
          selectInput(inputId = "choixCouleur",
                      label = "Choisir une couleur à filtré",
                      choices = c("D", "E", "F", "G", "H", "I", "J")),
          
          actionButton(inputId = "boutton",
                       label = "Visualiser le graph"
          )
        ),

        mainPanel(
          plotlyOutput(outputId = "DiamondPlot"),
          DTOutput(outputId = "DiamondTableau")
        )
    )
)

server <- function(input, output, session) {
  
  output$DiamondPlot <- renderPlotly({
    mygraph <- ggplot(data = diamonds) +
      aes(x =carat , y = price) +
      geom_point()
    
    ggplotly(mygraph)
    
    })
  observeEvent(input$boutton,{
    showNotification(
      paste("prix :", input$prix, "couluer:", input$choixCouleur),
      type = "message"
    )
  })
  
  output$DiamondTableau <- renderDT({
    diamonds %>% filter(price == input$prix)
  })
  
  
}


shinyApp(ui = ui, server = server)
