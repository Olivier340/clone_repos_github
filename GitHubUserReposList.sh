#!/bin/bash
# Author: Olivier GANDAIS
# Email: olivier@ogasphere.com
# Created Date: 17 mars 2022
# 

# Initialisation variables
source config.cfg

# Parent directory
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Org base URL
BASEURL="https://api.github.com/search/repositories?q=user:$USERNAME "

# No of reposoitories per page - Maximum Limit is 100
PERPAGE=100

cd ..
mkdir -p $DIR_OUTPUT_NAME
cd $DIR_OUTPUT_NAME
current_directory=`pwd`

if [ -e ReposList_$USERNAME.txt ]
then
    rm ReposList_$USERNAME.txt
fi

 (
 curl -H "Authorization: token $TOKEN" $BASEURL |
 grep -e 'ssh_url*' |
 cut -d \" -f 4 > ReposList_$USERNAME.txt

 for repo in `cat ReposList_$USERNAME.txt`
 do
   echo "Cloning ${repo} under ${current_directory}"
   sh "${SCRIPTPATH}/clone.sh" $repo $current_directory
 done
 )
 rm ReposList_$USERNAME.txt