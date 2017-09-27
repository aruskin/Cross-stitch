require(imager)
require(dplyr)

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
  
  observeEvent(input$button, {
    in.height <- isolate(input$height)
    in.colors <- isolate(input$ncolors)
    if(!is.null(stdObjects$origImg)){
      old.dim <- dim(stdObjects$origImg)[1:2]
      new.dim <- c(in.height*old.dim[1]/old.dim[2], in.height)
      img_rgb <- stdObjects$origImg %>%
        resize(size_x=new.dim[1], size_y=new.dim[2]) %>%
        as.data.frame(wide='c') 
      
      # Convert to Lab color space so that using Euclidean distance in k-means 
      # makes slightly more sense (to the human eye)
      lab_pix <- convertColor(select(img_rgb, c.1, c.2, c.3), 
                              from="Apple RGB", to="Lab")
      
      # Perform k-means clustering on pixels w/k as number of colors specified by user
      cluster.fit <- kmeans(x = lab_pix, centers = in.colors, nstart=10, iter.max = 100)
      
      # Use cluster centers to reassign pixels for pattern
      new_pix <- fitted(cluster.fit) %>%
        convertColor(from="Lab", to="Apple RGB")
      
      stdObjects$newImg <- array(c(matrix(new_pix[,1], nrow=in.height), #R
                                   matrix(new_pix[,2], nrow=in.height), #G
                                   matrix(new_pix[,3], nrow=in.height)), #B
                                 c(new.dim, 3)) %>% 
        as.cimg
      
      # Make color palette to display alongside pattern
      pal <- cluster.fit$center %>%
        as.data.frame %>%
        convertColor(from="Lab", to="Apple RGB") %>%
        .[rep(seq_len(nrow(.)), each=100),]
      stdObjects$palette <- array(c(matrix(pal[,1], ncol=nrow(pal)/10), #R
                                    matrix(pal[,2], ncol=nrow(pal)/10), #G
                                    matrix(pal[,3], ncol=nrow(pal)/10)), #B
                                  c(10, nrow(pal)/10, 3)) %>%
        as.cimg
    }
  })
  output$new <- renderPlot({
    if(!is.null(stdObjects$newImg))
      plot(stdObjects$newImg)
  })
  
  output$dlPattern <- downloadHandler(
    filename = "mypattern.png",
    content = function(file) {
      if(!is.null(stdObjects$newImg))
        save.image(stdObjects$newImg, file)
    }
  )
})

