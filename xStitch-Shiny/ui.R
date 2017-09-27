library(shiny)

fluidPage(
  fluidRow(
    column(4, 
           h4("Original image:"),
           plotOutput("orig"),
           br(),
           fileInput('inImage', 'Choose image file')),
    column(4, 
           numericInput('height', 'Desired height of project (in stiches):', value=100),
           sliderInput("ncolors", "Number of colors:", min = 1, max = 40, 
                       value=10, step=1),
           actionButton('button', 'Make pattern'),
           br(),
           br(),
           downloadButton('dlPattern', 'Download Pattern'),
           br(),
           br(),
           downloadButton('dlPalette', 'Download Palette')),
          
    column(4, 
           h4("Your pattern (1 pixel = 1 stitch):"),
           plotOutput("new"),
           h4("Your palette:"),
           plotOutput("pal")
          )
  )
)