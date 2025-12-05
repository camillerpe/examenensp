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
  
  rv <- reactiveValues(df = diamonds)

  observeEvent(input$boutton,{
    showNotification(
      paste("prix :", input$prix, "couleur:", input$choixCouleur),
      type = "default"
    )
  
  rv$df_filter <- diamonds %>% filter(price <= input$prix & color == input$choixCouleur)
  
  rv$df_select <- diamonds %>% filter(price <= input$prix & color == input$choixCouleur) %>% select(-x, -y, -z)
  
  rv$radioRose <- input$radio
  
  })
  
  output$DiamondPlot <- renderPlotly({
    radioCouleurGraph <- ifelse(rv$radioRose == 1, "pink", "black")
    mygraph <- ggplot(data = diamonds) +
      aes(x =carat , y = price) +
      geom_point(color = radioCouleurGraph) +
      labs(
        title = paste("prix :", input$prix, "couleur:", input$choixCouleur)
      )
    
    ggplotly(mygraph)
    
    })
  
  output$DiamondTableau <- renderDT({
    rv$df_select
  })
  
  
}


shinyApp(ui = ui, server = server)
