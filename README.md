# Github Clone

Clone all public and private repositories from a GitHub user or organization.

## Usage

#### open the file config_base.cfg to modify the variables needed to run it
&nbsp;
###### Your User name

>USERNAME=""

###### Your Org name

>ORGNAME=""

###### Your Token

<https://github.com/settings/tokens>
>TOKEN=""

&nbsp;
###### Folder where repositories will be stored

*example*
>DIR_OUTPUT_NAME="GitHub_Repos"

*GibHub_Repos will be created in the parent folder of the script*

&nbsp;

###### Set it to executable permission with some command like:

>chmod a+x GitHubUserReposList.sh

>chmod a+x GitHubOrgReposList.sh

###### Then Run the script

>./GitHubUserReposList.sh

to clone all your repositories
or
>./GitHubOrgReposList.sh

to clone all repositories of an organization

*after the execution of the script the file config_base.cfg will be automatically renamed config.cfg*
&nbsp;
#### Dépendance necessaire : jq

<https://stedolan.github.io/jq/>
> sudo apt install jq

That is so funny! :joy:
