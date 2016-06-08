#!/bin/sh
#Author : Ashay Maheshwari
#Purpose : To clone all github repositories of mentioned organization 


USAGE () {
 echo ""
 echo -e "ERROR      :  `date`  : Expects one argument. Please execute as given below \n"
 echo    "EXECUTION  :  `date`  : sh clone-repo.sh git-username"
 echo    "EXECUTION  :  `date`  : sh clone-repo.sh git-organization-name"
 echo ""
}


if [ "$#" -ne 1 ]; 
then
  USAGE 
  exit 1
fi

USER=$1;                                 #Initialize the username or organization name 
BKP_DIR="/root/deleteme"                 #Give the base path where every repository is cloned 
GIT_REPO_INFO="git-repo-info.txt"        #Variable contain the file name to hold all info related to git repo
URL_TO_CLONE="url_to_clone.txt"          #Varibale contain the file name to hold urls of all repo to be cloned 
REPOSITORY_NAMES="repository_names.txt"  #Variable contain the file name to hold the names of all repositories 


echo "INFO  :  `date`  :  Cloning Started " > $BKP_DIR/clone_start_time.txt

curl "https://api.github.com/users/$USER/repos?per_page=1000" > $BKP_DIR/$GIT_REPO_INFO

grep '"message": "Not Found"' $BKP_DIR/$GIT_REPO_INFO > /dev/null
if [ $? -eq 0 ] ; 
then
     echo  "ERROR  :  `date`  :  Mentioned github username does not exist " 
     exit 1 
fi

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
	echo "INFO  :  `date`  :  git pull for $repo_name : `git pull`"
done 

echo "INFO  :  `date`  :  Cloning Done " > $BKP_DIR/clone_stop_time.txt
