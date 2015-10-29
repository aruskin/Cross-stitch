library("EBImage")
library("grDevices")


imgReduction <- function(original, height, colors){
  img <- resize(original, h = height)
  img_mat = imageData(img)
  
  r <- as.vector(img_mat[,,1])
  g <- as.vector(img_mat[,,2])
  b <- as.vector(img_mat[,,3])
  pixels <- cbind(r, g, b)
  colnames(pixels) <- c("R", "G", "B")
  pixels <- as.data.frame(pixels)

  lab_pix = convertColor(pixels, from="Apple RGB", to="Lab")
  
  cl <- kmeans(x = lab_pix, centers = colors, nstart=10, iter.max = 100)
  
  new_pix <- fitted(cl)
  new_pix = convertColor(new_pix, from="Lab", to="Apple RGB")
  colnames(new_pix) <- c("R", "G", "B")
  new_pix = as.data.frame(new_pix)
  new_r <- matrix(new_pix$R, ncol=ncol(img_mat))
  new_g <- matrix(new_pix$G, ncol=ncol(img_mat))
  new_b <- matrix(new_pix$B, ncol=ncol(img_mat))
  
  new_img_data <- array(c(new_r, new_g, new_b), c(nrow(img_mat), ncol(img_mat), 3))
  new_img <- Image(new_img_data, c(nrow(img_mat), ncol(img_mat), 3), "Color")
  
  pal <- as.data.frame(cl$centers)
  pal = convertColor(pal, from="Lab", to="Apple RGB")
  pal = pal[rep(seq_len(nrow(pal)), each=100),]
  colnames(pal) <- c("R", "G", "B")
  pal = as.data.frame(pal)
  
  pal_r <- matrix(pal$R, ncol=nrow(pal)/10)
  pal_g <- matrix(pal$G, ncol=nrow(pal)/10)
  pal_b <- matrix(pal$B, ncol=nrow(pal)/10)
  
  
  pal_data <- array(c(pal_r, pal_g, pal_b), c(10, nrow(pal)/10, 3))
  pal_img <- Image(pal_data, c(10, nrow(pal)/10, 3), "Color")
  
  output <- list(pattern=new_img, palette=pal_img, pal_val=cl$centers)
  return(output)
}


#Testing
out = imgReduction(readImage("test_pic_botany.jpg"), height=125, colors=8)
display(out$palette)
display(out$pattern)
