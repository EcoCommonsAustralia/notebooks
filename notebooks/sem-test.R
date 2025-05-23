library(tidyverse)
# library(renv)

# # Activate the project library
# renv::init()

# # Install the required packages ("lavaan", "semPlot", "corrplot")
# renv::install(c("lavaan", "semPlot", "corrplot"))

# Load the required packages
library(lavaan)
library(semPlot)
library(corrplot)

buff_mose<-read.csv('https://www.dropbox.com/s/p138pj5xg9aksc4/1min_buffered_mose.csv?dl=1')


# histogram of time
hist(buff_mose$time, main = "Histogram of time", xlab = "Time (s)", col = "lightblue", border = "black")

# Display the detection depth of a tracker_id C5_20210429_115904_E_Twin-145.mp4_346 with y being the detection depth and x being the time
buff_mose %>%
  filter(tracker_id == "C5_20210429_115904_E_Twin-145.mp4_346") %>%
  ggplot(aes(x = time, y = detection_depth)) +
  geom_point() +
  labs(title = "Detection depth of C5_20210429_115904_E_Twin-145.mp4_346",
       x = "Time (s)",
       y = "Detection depth (m)") +
  theme_minimal()

# Display the 


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

#Step 4: Fit the SEM
fit <- sem(mod, data = dat2, sample.cov = dat_cov, sample.nobs = nrow(dat2))

#Step 5: Plot the SEM
 #Fit the SEM
  mod_fit <- sem(mod_cs, data = dat2, 
                 sample.cov = dat_cov)
  #Generate summary
  smod <- summary(fit)
  
  #Generate plot
  plot<-semPlot::semPaths(fit, what='est', residuals=F)
