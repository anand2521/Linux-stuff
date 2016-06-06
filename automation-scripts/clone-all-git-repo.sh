#!/bin/sh
#Author - Ashay Maheshwari. 
#Purpose - This script can be used to get the list of all the private repositories of a user and clone itin your local directory 

USER=ashay-maheshwari;

#command to get info about all the repo and fetch the url to clone 
curl "https://api.github.com/users/$USER/repos?per_page=1000" | grep "clone_url" | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g' > url_to_clone.txt

cat url_to_clone.txt | while read url 
do 
   git clone $url
done 
	

