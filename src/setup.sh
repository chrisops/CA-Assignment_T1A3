#!/bin/bash

printf "Installing bundled gems...\n\n"
sleep 1
bundle install


printf "\n\n**Invoice sending uses a mailjet API, Please go to mailjet.com and register for an API key, then enter your API key:**\n"
printf "API key:   "
read apikey
printf "API Secret Key:   "
read secretkey
printf "Email address:   "
read email

if [ ! -z $apikey ] && [ ! -z $secretkey ] && [ ! -z $email ]
then
printf "APIKEY=$apikey\n" > .env
printf "APISECRET=$secretkey\n" >> .env
printf "EMAIL=$email" >> .env
else
echo "Empty values not valid, run setup.sh again to reconfigure email"
fi

printf "\n**If there were any errors during setup, run:\n\nsudo apt-get install ruby-dev\n\nthen run bash setup.sh again to fix**\n\n"
