temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$main_dir"/temp.csv "$file_in"
fi
}
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
}
config_text() {
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=$search
main_dir=$main_dir
Lit_search_dir="$Lit_search_dir"" >> "$file_out"
}
config_defaults() {
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=Default Value
main_dir=Default Value
Lit_search_dir=Default Value" >> "$file_out"
}
create_stat() { 
cat "$file_in" | cut -d',' -f3,4,5,6,7 | sed -n '1p' | sed "s/,/\n/g" | awk '{$2=NR}1' | awk '{$3=$2+2}1' | awk '{$4="'$search'"}1' | sed 's/ /,/g' | sed 's/"//g' >> "$file_out" #makes a metadata names file for analysis
}
total_wabs() {
cat "$file_in" | sed 's/""/*NA*/g' | sed 's/"//g' | cut -d',' -f2  >> "$file_out" #removes all articles without an abstract and creates a list of PMID that contained abstracts
}
unique() {
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
Rscript --vanilla "$Lit_search_dir"/charts.R $file_in $file_out $name #creates a piechart from a file with frequency in column 1 and names in column2
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
set_cat_var() {
cat "$config" | sed '/^'$phrase'/ d' >> temp.txt
rm "$config" 
mv temp.txt "$config"
echo ""$phrase2"" >> "$Lit_search_dir"/config.cfg.defaults
} 
create_absearch() {
wkd="$dir_path"/final/"$search_cat";
new_dir="$wkd"
create_dir
for i in final totals charts ; do
  wkd="$dir_path"/final/"$search_cat";
  new_dir="$wkd"/"$i"
  create_dir
done
}
filter_abs() {
find "$file_in" -type f | xargs grep -n "$search" >> "$file_out"
cat "$file_out" | cut -d',' -f2 >> "$file_out2"
rm "$file_out"
}
run_ind_st() {
wkd="$dir_path"/final/"$search_cat";
file_in="$dir_path"/"$search"abstracts.csv;
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
    file_in2="$dir_path"/"$search"abPMID.csv;
    g_tot=$(cat "$file_in2" | wc -l);
    totals2=$(expr "$g_tot" - "$totals");
    column1=$(echo ""$search"other"); # labels with others
    column2="$totals2" # total number of articles with abstracts 
    find_totals2 # adds totals to file
    file_in="$wkd"/totals/"$search"totals.csv;
    sed -i 's/ /_/g' "$file_in"
    file_out="$wkd"/charts/"$search"totals.tiff;
    tool=chart;
    name=totals;
    run_tools # will create pie charts for search term against not search term
  fi
} 
fix_header() {
cat "$file_in" | awk -F',' '{ if ( $1 != "name" ) { print $1,$2; } }' | sed '1i name,freq' >> temp.csv
rm "$file_in"
mv temp.csv "$file_in"
sed -i 's/ /,/g' "$file_in"
}
search_term_matrix1() {
cat "$wkd"/* | sed '1d' | sort -iu | sed '1i name,freq' >> "$file_out"
}
search_term_matrix2() {
cat "$wkd"/* | sed '1d' | sort -id | sort -u | sed '1i name,freq' >> "$file_out"
}
search_term_matrix3() {
cat "$wkd"/* | sed '1d' | sort -id |sort -iu | sort -u | sed '1i name,freq' >> "$file_out"
}
search_term_matrix4() {
cat "$wkd"/* | sed '1d' | sort -id |sort -iu | sort -iu | sort -u | sed '1i name,freq' >> "$file_out"
}
total_cat_terms() {
wkd="$dir_path"/final/"$search_cat"/totals; #collection of PMID files for each search term
file_out="$dir_path"/final/"$search"total"$search_cat".csv; 
search_term_matrix1 #totals of articles for each search term
sed -i '/other/d' "$file_out"
}
barchart() {
Rscript --vanilla "$Lit_search_dir"/barchart.R $file_in $file_out #creates bar charts
} 
searchterm_bargraph() {
dir_path="$results_dir"/"$search"
file_in="$dir_path"/final/"$search"total"$search_cat".csv; #freq,search_cat
fix_header
file_in="$dir_path"/final/"$search"total"$search_cat".csv; #freq,search_cat
file_out="$dir_path"/final/"$search"total"$search_cat".tiff;
tool=barchart;
run_tools #creates number of articles for each search term grouped by category
} 
catgor_piechart() {
wkd="$dir_path"/final/"$search_cat"/final;
file_out="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"counts"$num".csv;
search_term_matrix"$num" #total number of articles for each category
file_in="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"counts"$num".csv;
file_out="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"abs"$num".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term
column1="$search_cat"; # labels file with search term,
column2="$totals"; # writes the count for the search term
header=no
find_totals
file_in2="$dir_path"/"$search"abPMID.csv;
file_out="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"abs"$num".csv;
file_in="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"counts"$num".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term
g_tot=$(cat "$file_in2" | wc -l);
totals2=$(expr "$g_tot" - "$totals"); 
column1="other then "$search_cat""; # labels file with search term,
column2="$totals2"; # writes the count for the search term 
find_totals2
file_in="$dir_path"/final/"$search_cat"/"$topic"total"$search_cat"abs"$num".csv; #freq,search_cat
file_out="$dir_path"/final/"$search_cat"/"$topic"total"$search_cat"abs"$num".tiff;
tool=chart;
run_tools #pie chart for all search terms at least once in a category against none found
} 
topic_bar_prep() {
file_in="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"counts"$num".csv;
file_out="$dir_path"/final/"$search"totalcatwtot"$num".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term
column1="$search_cat"
column2="$totals"
header=yes
find_totals #adds a row with search 
} 
topiccategory() {
search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from
file_in="$dir_path"/final/"$search_cat"/"$search"total"$search_cat"counts"$num".csv;
file_in2="$dir_path"/"$search"abPMID.csv;
file_out="$main_dir"/categories/"$search_cat".csv;
totals=$(cat "$file_in" | wc -l); #count how many articles for search term 
totalarticles=$(cat "$file_in2" | wc -l)
percent=$(perl -e "print "$totals"/"$totalarticles"*100")
column1="$search";
column2="$percent";
header=yes
find_totals
} 
topic_bar() {
#file_in="$dir_path"/"$topic"abPMID.csv;
#file_out="$dir_path"/final/"$topic"totalcatwtot.csv;
#totals=$(cat "$file_in" | wc -l); #count how many articles for search term
#column1=Total
#column2="$totals"
#header=yes
#find_totals
file_in="$dir_path"/final/"$search"totalcatwtot"$num".csv;
sed -i '1i name,freq' "$file_in"
file_out="$dir_path"/final/"$search"totalwtot"$num".tiff
tool=barchart;
run_tools # bar chart for each topic with categories showing how many found.
}
run_tools() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND $file_in STARTING $tool");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND "$file_in" FOR "$sample"");
  fi
  if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND $file_out FINISHED $tool");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND $file_out FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND $file_out FINISHED $tool")
  mes_out # ERROR OUTPUT IS THERE
fi
}
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$results_dir"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$results_dir"/time_check/"$run"time_check.csv
}
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
TIME_HOUR=$(date +%H)
TIME_MIN=$(date +%M)
TIME_SEC=$(date +%S)
#############################################################################################################
#SEARCH FOR KEY TERMS ***
################################################################################################################
main_dir="$1"; # user defined main directory
results_dir="$2"
new_dir="$2"
create_dir
Lit_search_dir="$main_dir"/Lit_search/scripts
file_in="$Lit_search_dir"/topics.csv
cat "$file_in" | sort -i >> "$main_dir"/temp.csv
temp_file
INPUT="$Lit_search_dir"/topics.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read -r search num_rec maxyear minyear
do
    main_dir="$1"; # user defined main directory
    Lit_search_dir="$main_dir"/Lit_search/scripts
    results_dir="$2"
    dir_path="$results_dir"/"$search";
    new_dir="$dir_path"
    create_dir #creates directories for results
    wkd="$dir_path"/final;
    new_dir="$wkd"
    create_dir
    file_out="$Lit_search_dir"/config.cfg;
    config_text #creates config file to store variables
    file_out="$main_dir"/config.cfg.defaults;
    config_defaults #creates more config files for variables
    echo1=$(echo "starting pubmed search for "$search"")
    mes_out
    file_outabs="$dir_path"/"$search"abstracts.csv; #names of pubmed search out put files
    file_outstats="$dir_path"/"$search"stats.csv;
    file_outsum="$dir_path"/summary.txt;
    num_rec=100000; #max number of records to return from pubmed
    if [[ ! -s "$file_outabs" && ! -s "$file_outstats" ]]; then
      #sed -i 's/search_topicfinal/"'$search'"/g' "$Lit_search_dir"/pubmed.R
      Rscript --vanilla "$Lit_search_dir"/pubmed.R $file_outabs $file_outstats $num_rec $search $maxyear $minyear #runs the Rscript to use RISmed to search pubmed database
      #sed -i 's/"'$search'"/search_topicfinal/g' "$Lit_search_dir"/pubmed.R
    else
      echo ""$file_outstats" and "$file_outabs" FOUND"
    fi
    file_in="$dir_path"/"$search"stats.csv
    file_out="$dir_path"/"$search"stat_names.csv
    tool=create_stat #gets article metadata ready for analysis
    run_tools 
    file_in="$dir_path"/"$search"abstracts.csv
    file_out="$dir_path"/"$search"abPMID.csv
    tool=total_wabs #gets article abstract file ready for analysis
    run_tools
    echo1=$(echo "pubmed search for "$search" done")
    mes_out
done
} < $INPUT
IFS=$OLDIFS
################################################################################################################
#CREATE PIECHART FOR EACH INDEX MEASURE IN STATS FROM PUBMED SEARCH ***
################################################################################################################
INPUT="$Lit_search_dir"/topics.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read -r search num_rec maxyear minyear
do
  main_dir="$1"
  Lit_search_dir="$main_dir"/Lit_search/scripts
  results_dir="$2"
  dir_path="$results_dir"/"$search"
  echo1=$(echo "starting summarizing results for "$search"")
  mes_out
  if [ "$topic" != "" ]; then
    cd "$Lit_search_dir"
    INPUT="$dir_path"/"$search"stat_names.csv
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while IFS=, read -r name num column search
    do
      source config.shlib; # load the directory variables
      main_dir="$1"
      results_dir="$2"
      dir_path="$results_dir"/"$search";
      new_dir="$dir_path"/stats
      create_dir
      wkd="$dir_path"/stats/"$name";
      new_dir="$wkd"
      create_dir
      file_in="$dir_path"/"$search"stats.csv;
      file_out="$wkd"/"$name".csv;
      file_out2="$main_dir"/topic_stats/"$search"stats.csv;
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
  fi
done
} < $INPUT
IFS=$OLDIFS
################################################################################################################
#CREATES TOTAL NUMBER OF ARTICLES FOUND FOR EACH TOPIC ***
################################################################################################################
INPUT="$Lit_search_dir"/topics.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read -r search num_rec maxyear minyear 
do
  main_dir="$1"
  Lit_search_dir="$main_dir"/Lit_search/scripts
  results_dir="$2"
  dir_path="$results_dir"/"$search"
  echo1=$(echo "starting summarizing results for "$search"")
  mes_out
  if [ "$topic" != "" ]; then
    file_in="$dir_path"/"$search"stats.csv;
    file_out="$results_dir"/totals.csv;
    if [ -s "$file_in" ]; then
      column1="$search";
      totals=$(cat "$file_in" | wc -l);
      column2="$totals";
      header=yes
      echo1=$("Starting totals for "$file_in"")
      mes_out
      echo ""$column1","$column2"" >> "$file_out" # this will find how many articles were found with metadata
    fi
    if [ -s "$file_in" ]; then
      file_in="$dir_path"/"$search"abPMID.csv
      file_out="$results_dir"/abstotal.csv
      column1="$search";
      totals=$(cat "$file_in" | wc -l);
      column2="$totals";
      header=yes
      echo1=$("Starting totals for "$file_in"")
      mes_out
      echo ""$column1","$column2"" >> "$file_out" # this will find how many articles were found with an abstract
    fi
  fi
done
} < $INPUT
IFS=$OLDIFS
################################################################################################################
#SEARCH THE ABSTRACTS FOR EACH **TERM** IN A CATAGORY AND MAKE GRAPHS ***
################################################################################################################
INPUT="$Lit_search_dir"/topics.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read -r  num_rec maxyear minyear 
do
  main_dir="$1"
  Lit_search_dir="$main_dir"/Lit_search/scripts
  results_dir="$2"
  dir_path="$results_dir"/"$search"
  config="$Lit_search_dir"/config.cfg.defaults
  phrase=$(echo "topic=")
  phrase2=$(echo "topic="$search"")
  set_cat_var
  echo1=$(echo "starting summarizing results for "$search"")
  mes_out
  if [ "$topic" != "" ]; then
    search_file="$Lit_search_dir"/search_terms.csv
    for number in {1..8} ;
    do 
      search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from search_terms file those are search term catagories
      if [ "$search_cat" != "" ]; then
        wkd="$dir_path"/final/"$search_cat";
        new_dir="$wkd"
        create_dir
        for i in final totals charts ; do
          wkd="$dir_path"/final/"$search_cat";
          new_dir="$wkd"/"$i"
          create_dir
        done
        config="$Lit_search_dir"/config.cfg.defaults
        phrase=$(echo "search_cat=")
        phrase2=$(echo "search_cat="$search_cat"")
        set_cat_var
        config="$Lit_search_dir"/config.cfg.defaults
        phrase=$(echo "catnum=")
        phrase2=$(echo "catnum="$number"")
        set_cat_var
        config="$Lit_search_dir"/config.cfg.defaults
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
            main_dir="$1"
            Lit_search_dir="$main_dir"/Lit_search/scripts
            results_dir="$2"
            dir_path="$results_dir"/"$search"
            cd "$Lit_search_dir" #cd directory to where config files are stored
            source config.shlib; # load the config library functions
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor1";
            run_ind_st # will create pie charts for search term against not search term
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms #PIECHARTS FOR EACH **CATEGORY BROKEN DOWN BY TERMS SEARCH_TERMS.CSV ***
          searchterm_bargraph #CHARTS FOR EACH TOPIC BROKEN DOWN BY CATEGORIES *(wont print bar) creates number of articles for each search term grouped by category
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor2";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor3";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor4";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor5";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor6";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor7";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
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
            source "$Lit_search_dir"/config.shlib; # load the config library functions
            cd "$Lit_search_dir" #cd directory to where config files are stored
            catnum="$(config_get catnum)";
            search_cat="$(config_get search_cat)";  
            search="$catgor8";
            run_ind_st
          done
          } < $INPUT
          IFS=$OLDIFS
          total_cat_terms # set up for charts later ***
          searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
          for num in 1 ;
          do
            catgor_piechart #pie chart for all search terms in a category against none found
            topic_bar_prep #bar graph for each topic.
            topiccategory
          done
        fi 
      fi
    done
    for num in 1 ;
    do
      topic_bar #x=categories in topic y=how many articles search term from each cat.
    done
################################################################################################################
# bar chart for total number of articles for each topic with or wout abstracts ***
################################################################################################################
    echo1=$(echo "graphs made for "$topic" done starting next topic")
    mes_out
  fi
done
} < $INPUT
IFS=$OLDIFS
################################################################################################################
# bar chart for total number of articles for each topic with or wout abstracts ***
################################################################################################################
echo1=$(echo "just wrapping up overall topics summary")
mes_out
wkd="$results_dir"/topic_stats;
new_dir="$wkd"
create_dir
file_out="$results_dir"/totals_list.csv;
search_term_matrix1 #makes a unique list of all main topics articles to find percentage of articles with each main topic
file_in="$results_dir"/abstotal.csv;
sed -i '1i name,freq' "$file_in"
file_out="$results_dir"/abstotal.tiff;
tool=barchart;
run_tools # will create bar chart for total number of articles with abstracts for each topic
file_in="$results_dir"/totals.csv;
sed -i '1i name,freq' "$file_in"
file_out="$results_dir"/totals.tiff;
tool=barchart;
run_tools # will create bar chart for total number of articles for each topic with or wout abstracts
################################################################################################################
# bar chart for total number of articles for each topic with or wout abstracts ***
################################################################################################################
for number in {1..8} ;
do 
  search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from
  if [ "$search_cat" != "" ];
  then
    file_in="$results_dir"/categories/
    new_dir="$file_in"
    create_dir
    file_in="$results_dir"/categories/"$search_cat".csv;
    file_out="$results_dir"/final/"$search_cat".tiff;
    sed -i '1i name,freq' "$file_in"
    tool=barchart;
    run_tools # will create bar chart for total number of articles with abstracts 
  fi
done
echo1=$(echo "done with the current topics summary")
mes_out
