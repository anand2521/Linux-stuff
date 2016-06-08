#!/bin/sh


USER=$1;                                 #Initialize the username or organization name 
BKP_DIR="/root/deleteme"                 #Give the base path where every repository is cloned 
GIT_REPO_INFO="git-repo-info.txt"        #Variable contain the file name to hold all info related to git repo
URL_TO_CLONE="url_to_clone.txt"          #Varibale contain the file name to hold urls of all repo to be cloned 
REPOSITORY_NAMES="repository_names.txt"  #Variable contain the file name to hold the names of all repositories 


echo "Cloning Started : `date` " > $BKP_DIR/clone_start_time.txt

curl "https://api.github.com/users/$USER/repos?per_page=1000" > $BKP_DIR/$GIT_REPO_INFO
cat $BKP_DIR/$GIT_REPO_INFO | grep "clone_url" | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g' > $BKP_DIR/$URL_TO_CLONE
cat $BKP_DIR/$GIT_REPO_INFO | grep '"name"' | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g' > $BKP_DIR/$REPOSITORY_NAMES

cd $BKP_DIR
cat $BKP_DIR/$URL_TO_CLONE | while read url 
do 
   git clone $url
   echo ""                                #Just for a blank line             
done 

cat $BKP_DIR/$REPOSITORY_NAMES | while read repo_name 
do 
        cd $BKP_DIR/$repo_name
	echo "git pull for $repo_name : `git pull`"
done 

echo "Cloning Done : `date` " > $BKP_DIR/clone_stop_time.txt
