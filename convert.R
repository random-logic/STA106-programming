input <- "Project2.ipynb"
rmarkdown::convert_ipynb(input, output = xfun::with_ext(input, "Rmd"))