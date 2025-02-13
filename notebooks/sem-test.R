library(tidyverse)
library(renv)

# Activate the project library
renv::init()

# Install the required packages ("lavaan", "semPlot", "corrplot")
renv::install(c("lavaan", "semPlot", "corrplot"))

buff_mose<-read.csv('https://www.dropbox.com/s/p138pj5xg9aksc4/1min_buffered_mose.csv?dl=1')


# histogram of time
hist(buff_mose$time, main = "Histogram of time", xlab = "Time (s)", col = "lightblue", border = "black")


# Filter out the X.2, X.1, X, time, tide_type, camera_location, spatial_angle_simple, distance_to_pipe
dat<-buff_mose %>% select(-c(X.2, X.1, X, time, tide_type, camera_location, spatial_angle_simple, distance_to_pipe, site))

#Step 3: Specify the SEM 
#We specify the model without the time splines, ensure that trait ~... is the last term as the splines will be pasted at the end

mod<- "
  trait1 =~ spatial_angle + spatial_speed + detection_depth + sinuosity
  trait1 ~ tide"

#remove non-numeric variables
dat2 <- dat %>%
transmute(across(where(is.numeric)))

#Covariance matrix
dat_cov<-cov(dat2, use="pairwise.complete.obs")
