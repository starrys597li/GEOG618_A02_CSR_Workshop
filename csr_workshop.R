### 1. Install the necessary packages
install.packages("spatstat") 
# provides a suite of tools for spatial point pattern analysis
install.packages("ggplot2")  
# provides a flexible and powerful framework for creating data visualizations in R
install.packages("maptools") 
# provides tools for reading, writing, and manipulating spatial data in R, including shapefiles, maps, and raster images
install.packages("sp")
# used for working with spatial data, such as shapefiles, grids, and other geospatial datasets

### 2. Load the necessary packages
library(spatstat)
library(ggplot2)
library(maptools)
library(sp)

### 3. Load the point pattern data (shapefile with projection)
points <- readShapePoints("D:/618shp/c2021GTArobberyoccur.shp")
# read the shp file
pp <- as.ppp(points)
# convert the shp file into a a point pattern dataset
unitname(pp) <- "meter"
# set the unit of the point pattern dataset be meter

################## Ripley's K-function ###############

## a. Create a spatial window to define the spatial extent of the study area
bbox <- bbox(points)
win <- owin(xrange = bbox[1,], yrange = bbox[2,])

### b. Calculate Ripley's K-function
Kfun_test <- Kest(pp)

### c. Plot the K-function
plot(Kfun_test, main = "Ripley's K-function")

### d. Calculate the confidence envelope. This function generates a simulated 
### envelope of K(r) under CSR, which can be used to assess whether the observed 
### K-function deviates significantly from CSR.
envK <- envelope(pp, Kest, nsim = 999)

### e. Plot the confidence envelope and the observed K-function
plot(envK, main = "Ripley's K-function (nsim=999)")

############### Besag's L-function ###############

### a. Calculate the Besag's L-function
L <- envelope(pp, Lest, nsim = 99)

# b. Plot the L-function and the confidence envelope
plot(L, main = "Besag's L-function", xlab = "Distance", ylab = "L(r)")
lines(L$theo, col = "red", lty = 2) # add the theoretical L-function as a dashed line
lines(L$upper, col = "black", lty = 2) # add the upper bound of the confidence interval as a dashed line
lines(L$lower, col = "black", lty = 2) # add the lower bound of the confidence interval as a dashed line

############### Clark and Evans' R-function ###############
### a. Calculate the Clark and Evans' R-function
ce <- clarkevans.test(pp)
ce
### b. Print the results to determine whether the point pattern is CSR or not. 
### The output will show the observed and expected values of R at each distance, 
### along with the p-value of the test.
ce_test_p_value <- ce$p.value

### c. Interpretation of results
if(ce_test_p_value >= 0.05){
  print("The observed spatial pattern is consistent with CSR.")
} else {
  print("The observed spatial pattern is not consistent with CSR.")
}
