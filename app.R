#!/usr/bin/Rscript

# app.R
# An example of calling the interactive plot function 'runPheWAS_vis.R'
# Using fake data but download 'runPheWAS_vis.R' and replace with your own data
# See details of usage of 'runPheWAS_vis.R' in its file
# Evonne McArthur 2/18

source('runPheWAS_vis.R') # sourcing the function
plotObjectOutputFromPhewas <- readRDS("my_plot.rds") # read in ggplot object

runPheWAS_vis(plotObjectOutputFromPhewas, directionality = TRUE, columnsInOutTable = c("phenotype","description","group","beta","SE","OR","p","n_total","n_cases","direction","size"))
