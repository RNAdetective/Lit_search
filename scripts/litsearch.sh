#!/usr/bin/env bash
create_dir() {
dp="$main_dir"/"$topic"; #set up directories
wkd="$dir_path"/final;
mwkd="$main_dir"/final;
wkd1="$dir_path"/stats;
mwkd1="$main_dir"/topic_stats;
catdir="$main_dir"/categories;
for i in "$dp" "$wkd" "$mwkd" "$wkd1" "$mwkd1" "$catdir" ;
do
  if [ ! -d "$i" ];
  then
  mkdir "$i"
  fi
done
}
config_text() {
file_out="$main_dir"/scripts/config.cfg;
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=$topic
main_dir=$main_dir
" >> "$file_out"
}
config_defaults() {
file_out="$main_dir"/scripts/config.cfg.defaults;
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=Default Value
main_dir=Default Value" >> "$file_out"
}
pubmed_search() {
file_outabs="$dir_path"/"$topic"abstracts.csv; #names of pubmed search out put files
file_outstats="$dir_path"/"$topic"stats.csv;
file_outsum="$dir_path"/summary.txt;
num_rec=100000; #max number of records to return from pubmed
if [[ ! -s "$file_outabs" && ! -s "$file_outstats" ]]; then
  Rscript --vanilla "$main_dir"/scripts/pubmed.R $topic $file_outabs $file_outstats $num_rec $file_outsum #runs the Rscript to use RISmed to search pubmed database
else
  echo ""$file_outstats" and "$file_outabs" FOUND"
fi
}
create_stat() { 
cat "$file_in" | cut -d',' -f3,4,5,6,7 | sed -n '1p' | sed "s/,/\n/g" | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' | sed 's/"//g' >> "$file_out" #makes a metadata names file for analysis
}
total_wabs() {
cat "$file_in" | sed 's/""/*NA*/g' | sed 's/"//g' | awk -F',' '{ if ( $4 != "*NA*" ) { print $2; } }' >> "$file_out" #removes all articles without an abstract and creates a list of PMID that contained abstracts
}
unique() {
cat "$file_in" | cut -d',' -f2 >> "$file_out2" #takes article list downloaded from pubmed and creates a PMIDlist
cat "$file_in" | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f$column_num | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed 's/"//g' | sed '1i freq,name' >> "$file_out" #counts number of unique PMID in article list for each of the metadata terms searched for and creates a file with columns frequencies and metadata variable names for example countrys would have USA, UK, Canada ect. 
}
Country() {
awk -F',' '{ if ( $1 <= 60 ) { print } }' "$file_out" >> "$file_out3" #prints file with countries that have less then 60 articles
awk -F',' '{ if ( $1 > 60 ) { print } }' "$file_out" >> "$file_out4" #makes a new file with the collapsed other value added
}
Year() {
awk -F',' '{ if ( $2 != "NA" ) { print } }' "$file_out" >> "$file_out4" #filters any article that does not have a date record in the metadata
}
chart() {
Rscript --vanilla "$main_dir"/scripts/charts.R $file_in $file_out $name #creates a piechart from a file with frequency in column 1 and names in column2
}
barchart() {
Rscript --vanilla "$main_dir"/scripts/barchart.R $file_in $file_out #creates bar charts
}
find_totals() {
if [[ ! -s "$file_out" && "$header" == "no" ]]; then
  add_header
fi
echo ""$column1","$column2"" >> "$file_out"
}
find_totals2() {
echo ""$column1","$column2"" >> "$file_out"
}
find_totals3() {
    if [[ ! -s "$file_out" && "$header" == "no" ]]; then
    add_header
    fi
    echo ""$column1","$column2","$column3"" >> "$file_out" 
}
add_header() {
echo "name,freq" >> "$file_out"
}
run_tools() {
if [ ! -s "$file_out" ]; then
  if [ -s "$file_in" ]; then
    "$tool"
  else 
    echo ""$file_in" MISSING"
  fi
else
echo ""$file_out" already FOUND"
fi
}
search_term_matrix1() {
cat "$wkd"/* | sed '1d' | sort -iu | sed '1i name,freq' >> "$file_out"
}
search_term_matrix2() {
cat "$wkd"/* | sed '1d' | sort -id | sort -u | sed '1i name,freq' >> "$file_out"
}
rmlast() {
cat "$file_in" | head -n -1 > temp.csv ; mv temp.csv "$file_in"
}
filter_abs() {
find "$file_in" -type f | xargs grep -n "$search" >> "$file_out"
cat "$file_out" | cut -d',' -f2 >> "$file_out2"
rm "$file_out"
}
create_absearch() {
wkd="$dir_path"/final/"$search_cat";
dtm="$wkd"
createdir
for i in final totals charts ; do
  wkd="$dir_path"/final/"$search_cat";
  dtm="$wkd"/"$i"
  createdir
done
}
fix_header() {
cat "$file_in" | awk -F',' '{ if ( $1 != "name" ) { print $1,$2; } }' | sed '1i name,freq' >> temp.csv
rm "$file_in"
mv temp.csv "$file_in"
sed -i 's/ /,/g' "$file_in"
}
createdir() {
if [ ! -d "$dtm" ];
then
  mkdir "$dtm"
fi
}
set_cat_var() {
cat "$config" | sed '/^'$phrase'/ d' >> temp.txt
rm "$config" 
mv temp.txt "$config"
echo ""$phrase2"" >> /home/user/lit_search/scripts/config.cfg.defaults
} 

run_ind_st() {
wkd="$dir_path"/final/"$search_cat";
topic="$(config_get topic)";
main_dir="$(config_get main_dir)";
dir_path="$main_dir"/"$topic";
file_in="$dir_path"/"$topic"abstracts.csv;
file_out="$dir_path"/"$search".csv;
file_out2="$wkd"/final/"$search"ID.csv;
tool=filter_abs;
run_tools #takes search term and finds PMID for abstracts containing that word
file_in="$wkd"/final/"$search"ID.csv;
file_out="$wkd"/totals/"$search"totals.csv;
  if [ -s "$file_in" ]; 
  then
    totals=$(cat "$file_in" | wc -l); #count how many articles for search term
    column1="$search"; # labels file with search term,
    column2="$totals"; # writes the count for the search term
    header=no
    find_totals
    file_in2="$dir_path"/"$topic"abPMID.csv;
    g_tot=$(cat "$file_in2" | wc -l);
    totals2=$(expr "$g_tot" - "$totals");
    column1=$(echo ""$search"other"); # labels with others
    column2="$totals2" # total number of articles with abstracts 
    find_totals2 # adds totals to file
    file_in="$wkd"/totals/"$search"totals.csv;
    file_out="$wkd"/charts/"$search"totals.tiff;
    tool=chart;
    name=totals;
    run_tools # will create pie charts for search term against not search term
  fi
} 
total_cat_terms() {
wkd="$dir_path"/final/"$search_cat"/totals; #collection of PMID files for each search term
file_out="$dir_path"/final/"$topic"total"$search_cat".csv; 
search_term_matrix1 #totals of articles for each search term
sed -i '/other/d' "$file_out"
} 
searchterm_bargraph() {
dir_path="$main_dir"/"$topic"
file_in="$dir_path"/final/"$topic"total"$search_cat".csv; #freq,search_cat
fix_header
file_in="$dir_path"/final/"$topic"total"$search_cat".csv; #freq,search_cat
file_out="$dir_path"/final/"$topic"total"$search_cat".tiff;
tool=barchart;
run_tools #creates number of articles for each search term grouped by category
} 
topiccategory() {
search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from
file_in="$dir_path"/final/"$topic"total"$search_cat".csv;
file_in2="$dir_path"/"$topic"abPMID.csv;
file_out="$main_dir"/categories/"$topic""$search_cat".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term 
totalarticles=$(cat "$file_in2" | wc -l)
percent=$(expr "$totals" / "$totalarticles")
column1="$topic";
column2="$percent";
header=yes
find_totals
} 
catgor_piechart() {
wkd="$dir_path"/final/"$search_cat"/final;
file_out="$dir_path"/final/"$topic"total"$search_cat"counts"$num".csv;
search_term_matrix"$num" #total number of articles for each category
file_in="$dir_path"/final/"$topic"total"$search_cat"counts"$num".csv;
file_out="$dir_path"/final/"$topic"total"$search_cat"abs"$num".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term
column1="$search_cat"; # labels file with search term,
column2="$totals"; # writes the count for the search term
header=no
find_totals
file_in2="$dir_path"/"$topic"abPMID.csv;
file_out="$dir_path"/final/"$topic"total"$search_cat"abs"$num".csv;
file_in="$dir_path"/final/"$topic"total"$search_cat"counts"$num".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term
g_tot=$(cat "$file_in2" | wc -l);
totals2=$(expr "$g_tot" - "$totals"); 
column1="other then "$search_cat""; # labels file with search term,
column2="$totals2"; # writes the count for the search term 
find_totals2
file_in="$dir_path"/final/"$topic"total"$search_cat"abs"$num".csv; #freq,search_cat
file_out="$dir_path"/final/"$topic"total"$search_cat"abs"$num".tiff;
tool=chart;
run_tools #pie chart for all search terms at least once in a category against none found
} 
topic_bar_prep() {
file_in="$dir_path"/final/"$topic"total"$search_cat"counts"$num".csv;
file_out="$dir_path"/final/"$topic"totalcatwtot"$num".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term
column1="$search_cat"
column2="$totals"
header=yes
find_totals #adds a row with search 
} 
topic_bar() {
#file_in="$dir_path"/"$topic"abPMID.csv;
#file_out="$dir_path"/final/"$topic"totalcatwtot.csv;
#totals=$(cat "$file_in" | wc -l); #count how many articles for search term
#column1=Total
#column2="$totals"
#header=yes
#find_totals
file_in="$dir_path"/final/"$topic"totalcatwtot"$num".csv;
sed -i '1i name,freq' "$file_in"
file_out="$dir_path"/final/"$topic"totalwtot"$num".tiff
tool=barchart;
run_tools # bar chart for each topic with categories showing how many found.
}
mes_out() {
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
}
#############################################################################################################
#SEARCH FOR KEY TERMS ***
################################################################################################################
maintopic1="$2" # uses defined main topics 1-6
maintopic2="$3"
maintopic3="$4"
maintopic4="$5"
maintopic5="$6"
maintopic6="$7"
for topic in "$maintopic1" "$maintopic2" "$maintopic3" "$maintopic4" "$maintopic5" "$main_topic6" ; do #enter search terms here
  if [ "$topic" != "" ]; then
    main_dir="$1"; # user defined main directory
    dir_path="$main_dir"/"$topic";
    create_dir #creates directories for results
    config_text #creates config file to store variables
    config_defaults #creates more config files for variables
    echo1=$(echo "starting pubmed search for "$topic"")
    mes_out
    pubmed_search #finds all pubmed articles for topic
    file_in="$dir_path"/"$topic"stats.csv
    file_out="$dir_path"/"$topic"stat_names.csv
    tool=create_stat #gets article metadata ready for analysis
    run_tools 
    file_in="$dir_path"/"$topic"abstracts.csv
    file_out="$dir_path"/"$topic"abPMID.csv
    tool=total_wabs #gets article abstract file ready for analysis
    run_tools
    echo1=$(echo "pubmed search for "$topic" done")
    mes_out
################################################################################################################
#CREATE PIECHART FOR EACH INDEX MEASURE IN STATS FROM PUBMED SEARCH ***
################################################################################################################
    INPUT="$dir_path"/"$topic"stat_names.csv
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while IFS=, read -r name num column
    do
      source "$1"/scripts/config.shlib; # load the directory variables
      cd "$1"/scripts # change directory to those files
      topic="$(config_get topic)";
      main_dir="$(config_get main_dir)";
      dir_path="$main_dir"/"$topic";
      wkd="$dir_path"/stats/"$name";
      dtm="$wkd"
      createdir
      file_in="$dir_path"/"$topic"stats.csv;
      file_out="$wkd"/"$name".csv;
      file_out2="$main_dir"/topic_stats/"$topic"stats.csv;
      column_num="$column";
      tool=unique;
      run_tools #will create unique list of files
      if [ "$name" == "Country" ];
      then
        file_out="$wkd"/"$name".csv;
        file_out3="$wkd"/"$name"lowcounts.csv;
        file_out4="$wkd"/"$name"new.csv;
        Country #preps metadata category countries to make pie charts
        file_in="$wkd"/"$name"lowcounts.csv;
        file_out="$wkd"/"$name"new.csv;
        totals=$(cat "$file_in" | awk -F',' '{s+=$1} END {print s}') 
        column1="$totals";
        column2=other;
        header=yes
        find_totals #sum of columns from file that contains low frequency to collapse all countries with less then 60 articles into an other
      fi
      if [[ "$name" == "YearA" || "$name" == "YearR" ]];
      then
        file_out="$wkd"/"$name".csv;
        file_out4="$wkd"/"$name"new.csv;
        Year #will get rid of articles that do not have a year in there metadata.
      fi 
      file_in="$wkd"/"$name"new.csv;
      file_out="$wkd"/"$name".tiff;
      tool=chart;
      run_tools # will create pie charts for each file
      cd
    done
    } < $INPUT
    IFS=$OLDIFS
################################################################################################################
#CREATES TOTAL NUMBER OF ARTICLES FOUND FOR EACH TOPIC ***
################################################################################################################
    file_in="$dir_path"/"$topic"stats.csv;
    file_out="$main_dir"/totals.csv;
    if [ -s "$file_in" ]; then
      column1="$topic";
      totals=$(cat "$file_in" | wc -l);
      column2="$totals";
      header=yes
      find_totals # this will find how many articles were found with metadata
    fi
    if [ -s "$file_in" ]; then
      file_in="$dir_path"/"$topic"abPMID.csv
      file_out="$main_dir"/abstotal.csv
      column1="$topic";
      totals=$(cat "$file_in" | wc -l);
      column2="$totals";
      header=yes
      find_totals # this will find how many articles were found with an abstract
    fi
################################################################################################################
#SEARCH THE ABSTRACTS FOR EACH **TERM** IN A CATAGORY AND MAKE GRAPHS ***
################################################################################################################
    search_file="$main_dir"/scripts/search_terms.csv
    for number in {1..8} ;
    do 
      search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from search_terms file those are search term catagories
      if [ "$search_cat" != "" ]; then
        create_absearch
        config=/home/user/lit_search/scripts/config.cfg.defaults
        phrase=$(echo "search_cat=")
        phrase2=$(echo "search_cat="$search_cat"")
        set_cat_var
        config=/home/user/lit_search/scripts/config.cfg.defaults
        phrase=$(echo "catnum=")
        phrase2=$(echo "catnum="$number"")
        set_cat_var
        config=/home/user/lit_search/scripts/config.cfg.defaults
        phrase=$(echo "search=")
        phrase2=$(echo "search=catgor"$catnum"")
        set_cat_var
        if [ "$number" == "1" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor1";
            run_ind_st # will create pie charts for search term against not search term
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms #PIECHARTS FOR EACH **CATEGORY BROKEN DOWN BY TERMS SEARCH_TERMS.CSV ***
          searchterm_bargraph #CHARTS FOR EACH TOPIC BROKEN DOWN BY CATEGORIES *(wont print bar) creates number of articles for each search term grouped by category
          topiccategory
          for num in {1..2} ;
          do
          catgor_piechart #pie chart for all search terms in a category against none found
          topic_bar_prep #bar graph for each topic.
          done
        fi
        if [ "$number" == "2" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor2";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          topiccategory
          for num in {1..2} ;
          do
          catgor_piechart #pie chart for all search terms in a category against none found
          topic_bar_prep #bar graph for each topic.
          done
        fi  
        if [ "$number" == "3" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor3";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          topiccategory
          for num in {1..2} ;
          do
          catgor_piechart #pie chart for all search terms in a category against none found
          topic_bar_prep #bar graph for each topic.
          done
        fi
        if [ "$number" == "4" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor4";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          topiccategory
          for num in {1..2} ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
          done
        fi  
        if [ "$number" == "5" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor5";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          topiccategory
          for num in {1..2} ;
          do
          catgor_piechart #pie chart for all search terms in a category against none found
          topic_bar_prep #bar graph for each topic.
          done
        fi
        if [ "$number" == "6" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor6";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          topiccategory
          for num in {1..2} ;
          do
          catgor_piechart #pie chart for all search terms in a category against none found
          topic_bar_prep #bar graph for each topic.
          done
        fi    
        if [ "$number" == "7" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor7";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in {1..2} ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
          done
        fi   
        if [ "$number" == "8" ];
        then
          INPUT="$search_file"
          {
          [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
          read
          while IFS=, read -r catgor1 catgor2 catgor3 catgor4 catgor5 catgor6 catgor7 catgor8
          do
            source /home/user/lit_search/scripts/config.shlib; # load the config library functions
            cd /home/user/lit_search/scripts #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor8";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          topiccategory
          for num in {1..2} ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
          done
        fi 
      fi
    done
    for num in {1..2} ;
    do
      topic_bar #x=categories in topic y=how many articles search term from each cat.
    done
################################################################################################################
# bar chart for total number of articles for each topic with or wout abstracts ***
################################################################################################################
    for number in {1..8} ;
    do 
      search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from
      if [ "$search_cat" != "" };
      then
        file_in="$main_dir"/categories/"$topic""$search_cat".csv;
        file_out="$main_dir"/"$topic""$search_cat".tiff;
        sed -i '1i name,freq' "$file_in"
        tool=barchart;
        run_tools # will create bar chart for total number of articles with abstracts 
      fi
    done
    echo1=$(echo "graphs made for "$topic" done starting next topic")
    mes_out
  fi
done
################################################################################################################
# bar chart for total number of articles for each topic with or wout abstracts ***
################################################################################################################
wkd="$main_dir"/topic_stats;
file_out="$main_dir"/totals_list.csv;
search_term_matrix1 #makes a unique list of all main topics articles to find percentage of articles with each main topic
file_in="$main_dir"/abstotal.csv;
sed -i '1i name,freq' "$file_in"
file_out="$main_dir"/abstotal.tiff;
tool=barchart;
run_tools # will create bar chart for total number of articles with abstracts for each topic
file_in="$main_dir"/totals.csv;
sed -i '1i name,freq' "$file_in"
file_out="$main_dir"/totals.tiff;
tool=barchart;
run_tools # will create bar chart for total number of articles for each topic with or wout abstracts
################################################################################################################
# bar chart for total number of articles for each topic with or wout abstracts ***
################################################################################################################
echo1=$(echo "done with the current topics")
mes_out


