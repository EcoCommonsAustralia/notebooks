# Load required package for JSON manipulation
library(jsonlite)

# Specify the input QMD file and desired output ipynb file
qmd_file <- "/Users/xiangzhaoqcif/dev/notebooks_zhaoxiangmax/notebooks/reclass_geotiff_notebook.qmd"        # Replace with your QMD file path
ipynb_file <- "/Users/xiangzhaoqcif/dev/notebooks_zhaoxiangmax/notebooks/reclass_geotiff_notebook.ipynb"    # Replace with your desired output file path

# Read the entire QMD file as lines
lines <- readLines(qmd_file, warn = FALSE)

# Initialize variables to store cells and current cell content/type
cells <- list()
current_cell_lines <- character(0)
current_type <- "markdown"  # default: outside code fence

# A helper function to add a cell to the list if content exists
add_cell <- function(cell_type, cell_lines) {
  # Trim any trailing newline
  cell_content <- paste(cell_lines, collapse = "\n")
  if (nchar(trimws(cell_content)) > 0) {
    # Create a cell list object. For code cells, set execution_count = NULL and outputs = list().
    if (cell_type == "code") {
      return(list(cell_type = "code", metadata = list(), execution_count = NULL, outputs = list(),
                  source = list(cell_content)))
    } else {
      return(list(cell_type = "markdown", metadata = list(),
                  source = list(cell_content)))
    }
  }
  return(NULL)
}

# Process each line to split into cells
inside_code <- FALSE
for (line in lines) {
  # Detect start of a code cell (we assume it starts with ```{r)
  if (grepl("^```\\{r", line)) {
    # If we were in markdown and have accumulated content, add it as a markdown cell
    if (!inside_code && length(current_cell_lines) > 0) {
      cell <- add_cell("markdown", current_cell_lines)
      if (!is.null(cell)) cells[[length(cells) + 1]] <- cell
      current_cell_lines <- character(0)
    }
    inside_code <- TRUE
    current_type <- "code"
    # Optionally, you could store code chunk options if needed by parsing the line.
    # Here we simply skip the opening code fence line.
    next
  }
  # Detect end of a code cell (a line that is exactly "```" optionally with spaces)
  if (inside_code && grepl("^```\\s*$", line)) {
    # End of code cell: add the accumulated lines as a code cell
    cell <- add_cell("code", current_cell_lines)
    if (!is.null(cell)) cells[[length(cells) + 1]] <- cell
    current_cell_lines <- character(0)
    inside_code <- FALSE
    current_type <- "markdown"
    next
  }
  # Otherwise, accumulate the line
  current_cell_lines <- c(current_cell_lines, line)
}

# After processing all lines, add any remaining cell content
if (length(current_cell_lines) > 0) {
  cell <- add_cell(ifelse(inside_code, "code", "markdown"), current_cell_lines)
  if (!is.null(cell)) cells[[length(cells) + 1]] <- cell
}

# Build the complete notebook structure
notebook <- list(
  cells = cells,
  metadata = list(language_info = list(name = "python")),
  nbformat = 4,
  nbformat_minor = 2
)

# Write the notebook to the output IPYNB file with pretty JSON formatting
write_json(notebook, ipynb_file, auto_unbox = TRUE, pretty = TRUE)

cat("Conversion complete. Your ipynb file is saved as:", ipynb_file, "\n")