#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
suppressPackageStartupMessages(library("RISmed"))
search_topic1 <- paste0(args[4])
search_topic2 <- paste0(args[5])
search_topic3 <- paste0(args[6])
search_topic4 <- paste0(args[7])
search_topic5 <- paste0(args[8])
search_topic6 <- paste0(args[9])
search_topic7 <- paste0(args[10])
search_topic8 <- paste0(args[11])
search_topic9 <- paste0(args[12])
search_topic10 <- paste0(args[13])
search_topicfinal <- print(paste0(search_topic1," ",search_topic2," ",search_topic3," ",search_topic4," ",search_topic5," ",search_topic6," ",search_topic7," ",search_topic8," ",search_topic9))
abs <- paste0(args[1]) #enter directory and name for abstracts to be stored
info <- paste0(args[2]) #enter directory and name for other pubmed information to be stored
search_query <- EUtilsSummary(search_topicfinal,retmax=paste0(args[3])) #runs pubmed search
summary(search_query)
print("Now getting these articles metadata and abstracts")
records <- EUtilsGet(search_query) #creates S4 object for search this is causing an error
pubmed_data <- data.frame('PMID'=PMID(records),'Title'=ArticleTitle(records),'Abstract'=AbstractText(records)) #pulls out abstracts
pubmed_data$Abstract <- as.character(pubmed_data$Abstract) 
pubmed_data$Abstract <- gsub(",", " ", pubmed_data$Abstract, fixed = TRUE) #removes commas in abstract
write.csv(pubmed_data, abs) #writes abstract text file
pubmed_data2 <- data.frame('PMID'=PMID(records),'Country'=Country(records),'YearA'=YearAccepted(records),'YearR'=YearReceived(records)) #pulls out other stats 
write.csv(pubmed_data2, info) #writes summary stats file a list of all PMID for your search
