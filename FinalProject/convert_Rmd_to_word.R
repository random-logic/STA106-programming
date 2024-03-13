# This R code converts an Rmd file to a word file
# For example, if input.Rmd is in the same path as this file:
input <- "input.Rmd" # You would change this
rmarkdown::render(input, output_format = "word_document")