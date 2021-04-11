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

printf "APIKEY=$apikey\n" > .env
printf "APISECRET=$secretkey" >> .env
printf "EMAIL=$email" >> .env