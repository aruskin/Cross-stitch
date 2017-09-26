# Cross-stitch
Program to convert images into cross stitch patterns

Version 1:
* Written in R (not necessarily ideal for speed, but easy-to-use implementations of image processing and clustering algorithms)
* User inputs image file, desired height of pattern (in terms of number of stitches), desired number of colors for pattern
* Program resizes image to input height (pixel = stitch), uses k-means to cluster pixels by color into input number of colors, 
replaces pixels with color of associated cluster centroids
* Outputs pattern and color palette

For next versions, may want:
* Language other than R
* GUI
* Matching to DMC thread colors
