curl --silent "http://weather.yahooapis.com/forecastrss?p=USNJ0415&u=f" | grep -E '(Current Conditions:|F<BR)' | sed -e 's/Current Conditions://' -e 's/<br \/>//' -e 's/<b>//' -e 's/<\/b>//' -e 's/<BR \/>//' -e 's///' -e 's/<\/description>//'

