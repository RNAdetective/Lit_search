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
   *whenever there is a graph the .csv with the same name is the file used to make the graph.

in the lit_search directory you will find 

   * totals_list.csv which is a list of the all the unique articles found between all the topics entered
   * abstotal.tiff is the bar graph for the number of articles with abstracts found for each topic
   * totals.tiff is bar graph of total number of articles found for each topic.

1.) Scripts with all the scripts and index files needed to run lit_search

2.) Categories folder csv file for graphs is the final folder

3.) Final folder with graphs for percent of total articles for each category compared between topics. A different bar graph for each topic.

4.) Topic_stats with the PMID for all the articles found for a topic.

5.) There will be a folder for each topic name from column 2 of your topics.csv file in the scripts folder.

   * In these folders you will find topicabPMID.csv which is the list of all the PMID that had abstracts with them,
   * topicabstracts.csv is the file with abstracts used for the search category search. 
   * ZIKVstat_names.csv is index file for data mining. 
   * ZIKVstats.csv which is metadata about each article downloaded.
   * There is also a folder called stats
      * In here is a folder for each meta data category country year accepted and year received (these can be changed manually in the Rscript)
      * In these folders you will find the pie chart and the csv files to make it.
   * There is also a folder called final
      * In here are the bargraphs for how many articles contained each search word by search category and topictotalwtot.tiff is the bargraph showing how many articles contained at least one search term shown by categories for the topic.
      * There is also a folder for each search category with a pie chart for how many articles contained at least one search term and the csv of all the unique PMID for that category.
      * Within charts folder you will find a pie chart for each individual search term number of articles compared to all for the topic.
      * Within final are the PMID list for each search term.
      * Within totals there are csv files for the charts in charts folder.

___

## Built With
R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [RISmed] (https://bioconductor.org/packages/release/bioc/html/RISmed.html)
* [ggplot2] (http://bioconductor.org/packages/release/bioc/html/ggplot2.html)

___

## References for tools.



