## Worktracker

Like many agencies we use a number of different tools to track our work.

We use

1. Assembla
2. Github
3. Idonethis

As a result, it can be hard to track what you need to be working on and what you got done
as the data is spread over a few places.

### This tool is meant to track

1. What you need to be working on
2. What did you got done for a specific day - as told by git logs.

###Features:

1. Displays the commits for each user for the selected date.
2. Displays all the tickets assigned to each user.

Supported Sites

1. Assembla

In progress

1. Github
2. Idonethis

###Usage:

    export ASSEMBLA_API_KEY=''
    export ASSEMBLA_API_SECRET=''
    export WORKTRACKER_AUTH_DOMAIN=''  Ex: agiliq.com
    
Put the above two lines in the bashrc file with approapriate values.

