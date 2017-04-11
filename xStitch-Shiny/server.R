library(imager)

shinyServer(function(input, output){
  stdObjects <- reactiveValues(origImg = NULL, newImg = NULL, palette = NULL)
  
  output$orig <- renderPlot({
    inFile <- input$inImage
    validate(
      need(!is.null(inFile), "Not a valid file input")
    )
    
    stdObjects$origImg <- load.image(inFile$datapath)
    plot(stdObjects$origImg)
  })
  
  ### Still need to deal with main functionality--i.e. converting image to 
  ### pattern--at some point
}
)
