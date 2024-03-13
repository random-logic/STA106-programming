# This R code converts an Rmd file to a pdf file
# For example, if input.Rmd is in the same path as this file:
input <- "input.Rmd" # You would change this
rmarkdown::render(input, output_format = "pdf_document")