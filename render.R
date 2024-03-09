# pdf does not format well, just make it a word file
input <- "HW6.Rmd"
rmarkdown::render(input, output_format = "word_document")