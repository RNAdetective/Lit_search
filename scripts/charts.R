#!/usr/bin/env Rscript
suppressPackageStartupMessages(library("ggplot2"))
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
# Pie Chart with Percentages for labels
file_in <- paste0(args[1]);
file_out <- paste0(args[2]);
name <- paste0(args[3]);
data_in <- read.csv(file_in);
if (name=="total") {
total <- data_in$freq[nrow(data_in)] 
data <- data_in[-nrow(data_in),]
} else {
total <- sum(data_in$freq)
data <- data_in
}
cols <- rainbow(nrow(data));
slices <- data$freq
lb_per <- paste0(round(data$freq/total*100,2),'%')
lb_name <- paste0(data$name)
lb_all <- paste0(lb_name," , ",lb_per)
title <- paste0("out of ",total," pubmed articles")
tiff(file_out, units="in", width=10, height=10, res=200)
pie(slices,labels=lb_all,col=cols,main=title);
garbage <- dev.off()
