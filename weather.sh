#!/bin/bash

zipcode=`curl -s http://ipinfodb.com/my_ip_location.php | awk '/Zip or postal code : /{print $6}' | awk '{gsub(//,"")}; 1' | sed "s#</li>##" | sed "s#[^0-9]##"` 
url="http://weather.yahooapis.com/forecastrss?p=$zipcode&u=f"

#curl --silent "$url" | grep -E '(Current Conditions:|F<BR)' |
#sed -e 's/Current Conditions://' -e 's/<br \/>//' -e 's/<b>//' -e 's/<\/b>//' -e 's/<BR \/>//' -e 's///' -e 's/<\/description>//' | tail -n1

curl --silent "$url" | grep -E '(<title>Conditions|F<BR)' | sed "s#<title>Conditions for \(.*\)at .*</title>#\1`printf "\033[1;31m::\033[0m"` #" | sed "s#<BR />##" | tr -d '\n'
