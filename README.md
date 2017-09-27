# Cross-stitch
Simple program to convert images into cross stitch patterns
* Program resizes image to input height (pixel = stitch), uses k-means to cluster pixels by color into input number of colors, 
replaces pixels with color of associated cluster centroids
* Outputs pattern and color palette

cross_stitch.R is a stand-alone script using EBImage library

xStitch-Shiny is a simple Shiny app to allow users to upload pictures, select number of stitches (for height) and number of colors in pattern, and then download generated pattern, all in a friendly GUI.  It uses the imager library.
The Shiny app also lives [here](https://ballerlikemahler.shinyapps.io/xStitch-Shiny/)


In the future, we may want to add:
* Matching to DMC thread colors?
* Some way to overlay grid lines on the images?
