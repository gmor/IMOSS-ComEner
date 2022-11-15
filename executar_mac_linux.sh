#/bin/bash

RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc"
Rscript -e "rmarkdown::render('~/GitHub/IMOSS-ComEner/Codi/NB.Rmd',output_format = rmarkdown::html_notebook(),
output_file='~/GitHub/IMOSS-ComEner/Veure_Resultats.html')"
exit 0