#!/bin/bash
# Author: Olivier GANDAIS
# Email: olivier@ogasphere.com
# Created Date: 17 mars 2022
# 
if [ -e config.cfg ]
then
  # Initialisation variables
  source config.cfg
else
    if [ -e config_base.cfg ]
    then 
      # Initialisation variables
      mv config_base.cfg config.cfg
      source config.cfg
    else
      echo "Vous devez créer un fichier de configuration nommé config.cfg"
    fi
fi


# Parent directory
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Org base URL
BASEURL="https://api.github.com/orgs/$ORGNAME/repos"

# No of reposoitories per page - Maximum Limit is 100
PERPAGE=100



cd ..
mkdir -p $DIR_OUTPUT_NAME
cd $DIR_OUTPUT_NAME
current_directory=`pwd`

if [ -e ReposList_$ORGNAME.txt ]
then
    rm ReposList_$ORGNAME.txt
fi


# Calculating the Total Pages after enabling Pagination
TOTALPAGES=`curl -I -i -u $USERNAME:$TOKEN -H "Accept: application/vnd.github.v3+json" -s ${BASEURL}\?per_page\=${PERPAGE} | grep -i link: 2>/dev/null|sed 's/link: //g'|awk -F',' -v  ORS='\n' '{ for (i = 1; i <= NF; i++) print $i }'|grep -i last|awk '{print $1}' | tr -d '\<\>' | tr '\?\&' ' '|awk '{print $3}'| tr -d '=;page'`
i=1

if [ -e $TOTALPAGES ]  # Solving the “Unary Operator Expected” Error
then
    TOTALPAGES=1
fi

# Browse pages
until [ $i -gt $TOTALPAGES ]
do
  # Get all repositories per page
  result=`curl -s -u $USERNAME:$TOKEN -H 'Accept: application/vnd.github.v3+json' ${BASEURL}?per_page=${PERPAGE}\&page=${i} 2>&1`
  echo $result > tempfile
  cat tempfile|jq '.[] |.ssh_url | @text'|tr -d '\\"' >> ReposList_$ORGNAME.txt  # Add list of repositories per page to ReposList_$ORGNAME.txt 
  ((i=$i+1))
done

while read line  
do   
   echo -e "$line" 
   # Clone all repositories in ListeDesRepos$ORGNAME.txt 
   # Call script cloner.sh
   sh "${SCRIPTPATH}/clone.sh" $line $current_directory
done < ReposList_$ORGNAME.txt

# Remove tempfile & ReposList_$ORGNAME.txt
rm tempfile
rm ReposList_$ORGNAME.txt

  