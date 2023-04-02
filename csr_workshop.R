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
points <- readShapePoints("D:/crime/c2021GTArobberyoccur.shp")
# read the shp file
pp <- as.ppp(points)
# convert the shp file into a a point pattern dataset
unitname(pp) <- "meter"
# set the unit of the point pattern dataset be meter

############# Ripley's K-function ##########

### a. Create a spatial window to define the spatial extent of the study area
bbox <- bbox(points)
win <- owin(xrange = bbox[1,], yrange = bbox[2,])

### b. Calculate Ripley's K-function
Kfun_test <- Kest(pp)

### c. Plot the K-function
plot(Kfun_test, main = "Ripley's K-function - 2021 GTA robbery occurrences")

### d. Calculate the confidence envelope. This function generates a simulated 
### envelope of K(r) under CSR, which can be used to assess whether the observed 
### K-function deviates significantly from CSR.
envK <- envelope(pp, Kest, nsim=100)

### e. Plot the confidence envelope and the observed K-function
plot(envK, main = "Ripley's K-function - 2021 GTA robbery occurrences")

########## Besag's L-function ##########

### a. Compute the observed and theoretical values of Besag's L-function using the Lest function
Lemp <- Lest(pp)
Ltheo <- envelope(pp, Lest, nsim = 99)

### b. Plot the observed and theoretical values of Besag's L-function
plot(Lemp, main = "Empirical and Theoretical L-function - 2021 GTA robbery occurrences", xlab = "r", ylab = "L(r)", col = "red")
plot(Ltheo, add = TRUE, col = "blue")
legend("bottomright", c("Empirical", "Theoretical"), col = c("red", "blue"), lty = 1)

########## Besag's L-function ##########
### a. Calculate the Clark and Evans' R-function
ce <- clarkevans.test(pp)


### b. Print the results to determine whether the point pattern is CSR or not. 
### The output will show the observed and expected values of R at each distance, 
### along with the p-value of the test.
ce
