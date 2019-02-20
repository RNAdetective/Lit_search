# About Lit_search
 
* Allows for searching pubmed with up to 6 main topics  
* Then it allows for up to 4 search categories of search terms to search articles found on the main topic.
* Creates pie charts for number of articles found containing search terms and for how many articles were found in each search category.
* Creates bar graphs summarized how many articles for each search term in a category and each category in a topic and also for how many results were found for each topic in the run.

___

## Getting Started
1.) Make sure you have the R packages ggplot2 and RISmed installed in R
2.) Download the compressed file and uncompress in your working directory.
3.) Fill out the search_terms.csv 
   1.) The first row contains the first search term with terms after it this tells the tool what your categories are named
   2.) the second row has to contain the first search term but this time without the terms at the end
4.) enter the following command into your terminal 
   1.) where topic is your search topic to collect articles from pubmed about.
   2.) ~ is the working directory where you uncompressed the lit_search file from github.
```
bash ~/lit_search/scripts/litsearch.sh ~/lit_search topic1 topic2 topic3 topic4 topic5 topic6
```
___

## Built With
R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [RISmed] (https://bioconductor.org/packages/release/bioc/html/RISmed.html)
* [ggplot2] (http://bioconductor.org/packages/release/bioc/html/ggplot2.html)

___

## References for tools.



