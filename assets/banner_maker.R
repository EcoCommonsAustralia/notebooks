library(magick)

img <- image_read("notebooks_banner_small.png")  # Replace with your image path

# Set the gradient colors
color1 <- "#f6aa70"  
color2 <- "#11aa96"  
color3 <- "#61c6fa"  

# Define the dimensions of the image and the border width
img_info <- image_info(img)
frame_width <- 15  # Adjust the border width

# Create a blank background image with dimensions that include the border
gradient_frame <- image_blank(width = img_info$width + 2 * frame_width, 
                              height = img_info$height + 2 * frame_width, 
                              color = "white")

# Use image_draw() to manually draw the gradient
gradient_frame <- image_draw(gradient_frame)

# Get the RGB components of the colors
col1_rgb <- col2rgb(color1)
col2_rgb <- col2rgb(color2)
col3_rgb <- col2rgb(color3)

# Draw the gradient frame for the left, center, and right parts
for (x in 1:(img_info$width + 2 * frame_width)) {
  if (x <= (img_info$width + 2 * frame_width) / 2) {
    # Gradient from color1 to color2
    ratio <- x / ((img_info$width + 2 * frame_width) / 2)
    color_mix <- rgb(
      (1 - ratio) * col1_rgb[1] + ratio * col2_rgb[1],
      (1 - ratio) * col1_rgb[2] + ratio * col2_rgb[2],
      (1 - ratio) * col1_rgb[3] + ratio * col2_rgb[3],
      maxColorValue = 255
    )
  } else {
    # Gradient from color2 to color3
    ratio <- (x - (img_info$width + 2 * frame_width) / 2) / ((img_info$width + 2 * frame_width) / 2)
    color_mix <- rgb(
      (1 - ratio) * col2_rgb[1] + ratio * col3_rgb[1],
      (1 - ratio) * col2_rgb[2] + ratio * col3_rgb[2],
      (1 - ratio) * col2_rgb[3] + ratio * col3_rgb[3],
      maxColorValue = 255
    )
  }
  
  # Draw each pixel column in the border area
  rect(x, 0, x + 1, img_info$height + 2 * frame_width, col = color_mix, border = NA)
}

# Finish drawing
dev.off()

# Composite the gradient frame and the image
img_with_gradient_frame <- image_composite(gradient_frame, img, offset = paste0("+", frame_width, "+", frame_width))

# Display the image with the gradient border
plot(img_with_gradient_frame)

library(ggplot2)

# Save the image with the gradient frame as a PNG
image_write(img_with_gradient_frame, path = "notebooks_banner_withframe.png", format = "png")

# Assuming img_with_gradient_frame is the image object created with magick
raster_img <- as.raster(img_with_gradient_frame)

install.packages("gridSVG")
library(grid)
library(gridSVG)

# Set up the SVG device with the desired dimensions (width = 117, height = 20)
svg("raster_image.svg", width = 117/72, height = 20/72, res = 300)  # Convert to inches for width/height

# Plot the raster image using grid
grid.raster(raster_img, width = unit(1, "npc"), height = unit(1, "npc"))

# Close the SVG device, saving the output
dev.off()

# Get the dimensions of the image
img_dims <- dim(raster_img)  # The dimensions will be in the format [height, width]
img_dims

# Calculate the aspect ratio
aspect_ratio <- img_dims[1] / img_dims[2]

# Create the ggplot, preserving the aspect ratio
p <- ggplot() +
  annotation_raster(raster_img, xmin = 0, xmax = 1, ymin = 0.4, ymax = aspect_ratio + 0.4) +
  theme_void() +  # Remove axes and background
  coord_fixed(ratio = 1)  # Preserve aspect ratio by fixing the coordinate system

ggsave("raster_image.svg", plot = p, width = 1618/72*2, height = 195/72*2, device = "svg")
svg_image <- image_read("raster_image.svg")
print(svg_image)
