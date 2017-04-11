library(shiny)

fluidPage(
  fluidRow(
    column(4, 
           plotOutput("orig"),
           br(),
           fileInput('inImage', 'Choose image file')),
    column(4, 
           numericInput('height', 'Desired height of project (in stiches):', value=100),
           sliderInput("ncolors", "Number of colors:", min = 1, max = 40, 
                       value=10, step=1)),
          
    column(4, 
           plotOutput("new"),
           br(),
           downloadButton('dlPattern', 'Download Pattern'))
  )
)