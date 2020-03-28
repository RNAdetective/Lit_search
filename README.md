# About Lit_search
 
* Allows for searching pubmed with unlimited main one word search terms
* Then summaries number of articles found for each search term by country and dates
* Additional search topics can be supplied to look for in abstracts or titles these will then be displayed as tables and graphs.

___

## Getting Started
1.) gitclone https://github.com/RNAdetective/Lit_search.git

2.) Find the /home/user/Lit_search directory

   * Find file topics.csv and fill in column 1=search term (currently one word only), column 2=number of searches to return, column 3=beginning year to search for, column 4=end year to search for
   
   * Find file search_terms.csv column 1=enter header name for your search category then in each row in the column put the specific word to look for currently only one word allowed, column 2=enter header name for your 2nd search category then in each row in the column put the specific word to for currently only one word allowed. You can enter up to 8 columns in this fashion.

   
3.) enter the following command into your terminal 

   * home_directory = the directory where your Lit_search folder is located
   * Results_directory = the directory where you would like your results to go
   
```
bash ~/lit_search/scripts/litsearch.sh home_directory Results_directory
```
___


## Output Files
Coming soon!

___

## Built With
R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [RISmed] (https://bioconductor.org/packages/release/bioc/html/RISmed.html)
* [ggplot2] (http://bioconductor.org/packages/release/bioc/html/ggplot2.html)

___

## References for tools.



