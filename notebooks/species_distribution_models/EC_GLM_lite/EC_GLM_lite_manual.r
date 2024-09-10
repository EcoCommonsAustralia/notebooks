# Set Workspace as the current working directory
Workspace <- getwd() 
#Workspace <- "/DIR"      #change directory

#The cat function in useful for displaying messages and debugging information.
cat("Workspace:", Workspace, "\n")

# Create the 'raw_data' directory within the current and parent working directory
dir.create(file.path(Workspace, "raw_data"), recursive = TRUE)

# supress warnings
options(warn= -1)

# specify the packages of interest
packages <- c("dismo", "ggplot2", "raster", "googledrive", "sp", "dplyr", "terra")

# now load all or install&load all from CRAN
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

search()

#R Markdown documents to configure the default behavior of code chunks
knitr::opts_chunk$set(echo = TRUE)

# De-authenticate Google Drive to access public files
drive_deauth()

# Google Drive file IDs
csv_file_id <- "12ej_b-e2N1qUGH6WyoWbkEHqNUTdfD2u"   
grd_file_id_current<- "1IDrfCzAyf3C3QYs6EhTCU8gsaIsmVbWV"   
gri_file_id_current <- "1MrCOmOl8d_ZPN6GrNfMSVCz219Nki4FF"  
grd_file_id_forecast <- "1iOgUZsUxyg8HF6V_4pV3QTQb1Z7B1QmN"   
gri_file_id_forecast <- "106fNjf5VaAdue9Q02BghXZeLqPM7qCYm"

# Download files to the 'raw_data' directory
drive_download(as_id(csv_file_id), path = file.path(Workspace, "raw_data", "tree_kangaroo.csv"), overwrite = TRUE)
drive_download(as_id(grd_file_id_current), path = file.path(Workspace, "raw_data", "env_current.grd"), overwrite = TRUE)
drive_download(as_id(grd_file_id_forecast), path = file.path(Workspace, "raw_data", "env_forecast.grd"), overwrite = TRUE)
drive_download(as_id(gri_file_id_current), path = file.path(Workspace, "raw_data", "env_current.gri"), overwrite = TRUE)
drive_download(as_id(gri_file_id_forecast), path = file.path(Workspace, "raw_data", "env_forecast.gri"), overwrite = TRUE)

# Confirm the files have been downloaded
cat("Downloaded files:", list.files(file.path(Workspace, "raw_data")), "\n")

# Read the tree kangaroo data
tree_kangaroo_path <- file.path(Workspace, "raw_data", "tree_kangaroo.csv")
tree_kangaroo_data <- read.csv(tree_kangaroo_path)

# Inspect the first few rows of the data
head(tree_kangaroo_data)

# Check data classes
sapply(tree_kangaroo_data, class)

# Convert character columns to numeric (if any)
tree_kangaroo_data <- tree_kangaroo_data %>% mutate(across(where(is.character), as.numeric))

# Check data classes after transformation
sapply(tree_kangaroo_data, class)

path <- file.path(Workspace, "raw_data", "tree_kangaroo.csv")
tree_kangaroo_data <- read.csv(path)
head(tree_kangaroo_data)
#check data class
sapply(tree_kangaroo_data, class)
#change data class to numeric
tree_kangaroo_data <- tree_kangaroo_data %>% mutate(across(where(is.character), as.numeric))
#check again
sapply(tree_kangaroo_data, class)

# Load environmental raster data
env_data_current <- rast(file.path(Workspace, "raw_data", "env_current.grd"))
env_data_forecast <- rast(file.path(Workspace, "raw_data", "env_forecast.grd"))

# Print summaries for the raster files
print(env_data_current)
print(env_data_forecast)

# Plot temperature and precipitation layers
plot(env_data_current$tmin, main = "Current Temperature")
plot(env_data_current$precip, main = "Current Precipitation")
plot(env_data_forecast$tmin, main = "Forecast Temperature")
plot(env_data_forecast$precip, main = "Forecast Precipitation")

# Extract raster values for tree kangaroo locations
tk_locations <- select(tree_kangaroo_data, lon, lat)

# Check if the extracted locations are valid
tk_env <- extract(env_data_current, tk_locations)

# Combine tree kangaroo data with extracted environmental data
tree_kangaroo_data <- cbind(tree_kangaroo_data, tk_env)

# Print out the first few rows of the updated data
head(tree_kangaroo_data)

# Check the structure and data types again
str(tree_kangaroo_data)

# Let us visualize the relationships between variables.
ggplot(tree_kangaroo_data, 
       mapping = aes(x = tmin, y = precip, color = factor(present))) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "loess", se = FALSE, color = "black") +
  labs(title = "Presence vs Environmental Variables",
       x = "Minimum Temperature (tmin)",
       y = "Precipitation (precip)",
       color = "Presence") +
  theme_minimal()

  #Occurance on X & envir on Y
#Probability low or high for multiple variables

logistic_regr_model <- glm(present ~ tmin + precip,
                           family = binomial(link = "logit"),
                           data = tree_kangaroo_data)
summary(logistic_regr_model)

str(env_data_forecast)
summary(env_data_forecast)
summary(env_data_current)
model_vars <- names(coef(logistic_regr_model))
missing_vars <- setdiff(model_vars, names(env_data_forecast))

if (length(missing_vars) > 0) {
  print(paste("Missing variables in env_data_forecast:", paste(missing_vars, collapse = ", ")))
}

#assign presence and absences to respective data
presence_data <-filter(tree_kangaroo_data,present ==1)
absence_data <-filter(tree_kangaroo_data,present ==0)

# Evaluate the model
evaluation <- evaluate(presence_data, absence_data, logistic_regr_model)

# Plot ROC curve and calculate AUC
plot(evaluation, "ROC")
cat("AUC:", evaluation@auc, "\n")

predictions <- predict(env_data_current, logistic_regr_model, type = "response")
plot(predictions, ext = extent(140, 154, -20, -10))
points(presence_data[c("lon", "lat")], pch = "+", cex = 0.5)

# Plot predictions with threshold
threshold <- threshold(evaluation, stat = "prevalence")
#30% threshold
plot(predictions>0.3, ext =extent(138, 154, -30, -10))

# Same for future
forecasts <- predict(env_data_forecast, logistic_regr_model, type = "response")
plot(forecasts > 0.3, ext = extent(138, 154, -30, -10))

# Compare future and current predictions
plot(forecasts - predictions, ext = extent(140, 154, -20, -10))

#### End####
# Open for dicussion 
## Output options
install.packages(c("knitr","rmarkdown","tinytex"))
tinytex::install_tinytex()  # Installs TinyTeX, a minimal LaTeX distribution
tinytex::reinstall_tinytex()  # Reinstalls TinyTeX in case it’s corrupted

# Load necessary libraries
library(knitr)
library(rmarkdown)

# Define the name of the notebook
notebook_name <- "EC_GLM_lite"

# Create the output folder
output_dir <- "output"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Convert notebook to RMarkdown (.Rmd) and save in the output folder
purl(paste0(notebook_name, ".ipynb"), output = file.path(output_dir, paste0(notebook_name, ".Rmd")))

# Knit the RMarkdown file to HTML and save in the output folder
render(file.path(output_dir, paste0(notebook_name, ".Rmd")), 
       output_format = "html_document", 
       output_dir = output_dir)

# Knit the RMarkdown file to PDF and save in the output folder
render(file.path(output_dir, paste0(notebook_name, ".Rmd")), 
       output_format = "pdf_document", 
       output_dir = output_dir)

# Export R script (.R) and save in the output folder
purl(paste0(notebook_name, ".ipynb"), output = file.path(output_dir, paste0(notebook_name, ".R")))

render(file.path(output_dir, paste0(notebook_name, ".Rmd")), 
       output_format = "pdf_document", 
       output_dir = output_dir)

#Alternative 
render(file.path(output_dir, paste0(notebook_name, ".Rmd")), 
       output_format = "pdf_document", 
       output_options = list(latex_engine = "xelatex"))

# Install caret package if not already installed
install.packages("caret")

# Load caret package
library(caret)


set.seed(42)
cv_model <- train(present ~ tmin + precip + tmin:precip,
                  data = tree_kangaroo_data,
                  method = "glm",
                  family = binomial,
                  trControl = trainControl(method = "cv", number = 5))
print(cv_model)

install.packages(glmnet)
library(glmnet)

x <- model.matrix(present ~ tmin + precip + tmin:precip, tree_kangaroo_data)
y <- tree_kangaroo_data$present

lasso_model <- cv.glmnet(x, y, family = "binomial", alpha = 1)
plot(lasso_model)

install.packages(car)
library(car)
vif(logistic_regr_model)
