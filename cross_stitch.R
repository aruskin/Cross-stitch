if("EBImage" %in% rownames(installed.packages()) == FALSE){
  source("https://bioconductor.org/biocLite.R")
  biocLite("EBImage")
}

library(EBImage)
library(grDevices)
library(dplyr)

imgReduction <- function(original, height, n_colors){
  img_mat <- resize(original, h = height) %>%
    imageData
  
  # Image data stored as 3d array, with R, G, and B values in separate 2d 
  # matrices of (width) x (height) pixels. For clustering by color, I think 
  # we don't care about the relative positions of the pixels.
  pixels <- cbind(as.vector(img_mat[,,1]), #R
                  as.vector(img_mat[,,2]), #G
                  as.vector(img_mat[,,3])) #B
  
  # Convert to Lab color space so that using Euclidean distance in k-means 
  # makes slightly more sense (to the human eye)
  lab_pix <- convertColor(pixels, from="Apple RGB", to="Lab")
  
  # Perform k-means clustering on pixels w/k as number of colors specified by user
  cluster.fit <- kmeans(x = lab_pix, centers = n_colors, nstart=10, iter.max = 100)
  
  # Use cluster centers to reassign pixels for pattern
  new_pix <- fitted(cluster.fit) %>%
    convertColor(from="Lab", to="Apple RGB")
  new_img <- array(c(matrix(new_pix[,1], ncol=ncol(img_mat)), #R
                          matrix(new_pix[,2], ncol=ncol(img_mat)), #G
                          matrix(new_pix[,3], ncol=ncol(img_mat))), #B
                        c(nrow(img_mat), ncol(img_mat), 3)) %>%
    Image(c(nrow(img_mat), ncol(img_mat), 3), "Color")
  
  # Make color palette to display alongside pattern
  pal <- cluster.fit$center %>%
    as.data.frame %>%
    convertColor(from="Lab", to="Apple RGB") %>%
    .[rep(seq_len(nrow(.)), each=100),]
  pal_img <- array(c(matrix(pal[,1], ncol=nrow(pal)/10), #R
                      matrix(pal[,2], ncol=nrow(pal)/10), #G
                      matrix(pal[,3], ncol=nrow(pal)/10)), #B
                    c(10, nrow(pal)/10, 3)) %>%
    Image(c(10, nrow(pal)/10, 3), "Color")
  
  list(pattern=new_img, palette=pal_img, pal_val=cluster.fit$centers)
}


#Testing
out <- imgReduction(readImage("test_pic_botany.jpg"), height=125, n_colors=8)
display(out$palette)
display(out$pattern)
