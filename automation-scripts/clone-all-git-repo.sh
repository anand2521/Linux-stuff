#!/bin/sh
#Author - Ashay Maheshwari
#Purpose - To clone all public github repositories of a github user. 

USER=ashay-maheshwari;                   #Initialize the username or organization name 
REPO_PATH="/root/deleteme"               #Give the base path where every repository is cloned 
GIT_REPO_INFO="git-repo-info.txt"        #Variable contain the file name to hold all info related to git repo
URL_TO_CLONE="url_to_clone.txt"          #Varibale contain the file name to hold urls of all repo to be cloned 
REPOSITORY_NAMES="repository_names.txt"  #Variable contain the file name to hold the names of all repositories 

curl "https://api.github.com/users/$USER/repos?per_page=1000" > $REPO_PATH/$GIT_REPO_INFO
cat $REPO_PATH/$GIT_REPO_INFO | grep "clone_url" | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g' > $REPO_PATH/$URL_TO_CLONE
cat $REPO_PATH/$GIT_REPO_INFO | grep '"name"' | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g' > $REPO_PATH/$REPOSITORY_NAMES

cd $REPO_PATH
cat $REPO_PATH/$URL_TO_CLONE | while read url 
do 
   git clone $url
done 
cat $REPO_PATH/$REPOSITORY_NAMES | while read repo_name 
do 
	cd $REPO_PATH/$repo_name
	git pull
done 

