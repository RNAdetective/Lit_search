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
   
   ***If you have more then one search term for your topic you can run RISmed manually with the following command where topic_name is the name of topic for the folder system and topic1-10 are the search terms to combine for your topic.  For example topic_name = ZIKV and topic1 = ZIKV topic2 = AND topic3 = zika topic4 = zikv topic5 = OR topic6 = ZIKV and so on. Then you can run the litsearch.sh file after for the rest of the single term topics
   
   ```
   Rscript ~/lit_search/scripts/pubmedman.R ~/lit_search/topic_name/topic_nameabstract.csv ~/lit_search/topic_name/topic_namestats.csv 100000 topic1 topic2 topic3 topic4 topic5 topic6 topic7 topic8 topic9 topic10
   
   ```
   

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


## Output Files



___

## Built With
R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [RISmed] (https://bioconductor.org/packages/release/bioc/html/RISmed.html)
* [ggplot2] (http://bioconductor.org/packages/release/bioc/html/ggplot2.html)

___

## References for tools.



