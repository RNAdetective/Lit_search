# About Lit_search
 
* Allows for searching pubmed with unlimited main one word topics  
* Then it allows for up to 8 search categories of unlimited number of search terms to search articles already collected on the main topic.
* Creates pie charts for number of articles found containing search terms and for how many articles were found in each search category.
* Creates bar graphs summarized how many articles for each search term in a category and each category in a topic and also for how many results were found for each topic in the run.

___

## Getting Started
1.) Make sure you have the R packages ggplot2 and RISmed installed in R

2.) Download the compressed file and uncompress in your working directory.

3.) Fill ou the topics.csv file in the lit_search/scripts/ directory

   * The first column is for the topics you would like to search for currenly it is single term only
   
   * The second column is for what you would like to name that topic for the file system

4.) Fill out the search_terms.csv in the lit_search/scripts/ directory

   * The first row contains the first search term with terms after it this tells the tool what your categories are named
   
   * The second row and on is for single term list of what you would like to search for
   
5.) enter the following command into your terminal 

   * Where topic is your search topic to collect articles from pubmed about.
   
   * Where ~ is the working directory where you uncompressed the lit_search file from github.
   
```
bash ~/lit_search/scripts/litsearch.sh ~/lit_search
```
___

## Built With
R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [RISmed] (https://bioconductor.org/packages/release/bioc/html/RISmed.html)
* [ggplot2] (http://bioconductor.org/packages/release/bioc/html/ggplot2.html)

___

## References for tools.



