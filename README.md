# PheWAS_vis

Evonne McArthur 2/2018

Made during rotation in Lea Davis' Lab (https://complextraitgenomics.org/)


An interactive visualization tool for the PheWAS R package (https://github.com/PheWAS/PheWAS). This allows you to interact with the PheWAS manhattan plots in order to better understand the data. Interactivity was achieved with Shiny (https://shiny.rstudio.com/).


See the functionality with sample dataset "my_plot.rds" in R console by running:
```
library(ggplot2)
library(shiny)
runGitHub("PheWAS_vis", "emcarthur")
```

Apply to your own datasets by downloading 'runPheWAS_vis.R' into your working directory.
Ouput the phewas plot to a variable name of your choice, here we use 'my_plot'. Learn more about and practice using PHeWAS here (https://github.com/PheWAS/PheWASExamples/blob/master/BMI%20FTO/BMI%20FTO%20walkthrough.Rmd) but this is an example of how this would look:

```
# results=phewas(phenotypes=names(phenotypes)[-1], genotypes=c("rs8050136_A"), covariates=c("age", "is.male"), data=data, cores=1)
my_plot <- phewasManhattan(results)
```
Source the function 'runPheWAS_vis.R' by running it or with:
```
source('runPheWAS_vis.R')
```
Now give your 'my_plot' data to the 'runPheWAS_vis' function with whatever parameters you would like. Some examples:
```
runPheWAS_vis(my_plot, directionality = TRUE, columnsInOutTable = c("phenotype","description","group","beta","SE","OR","p","n_total","n_cases","direction","size"))
runPheWAS_vis(my_plot)
runPheWAS_vis(my_plot, directionality = FALSE, heightOfPlot = 1000)
```
See more info about parameters to play with in the 'runPheWAS_vis.R' file
