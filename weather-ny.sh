zipcode=`curl -s http://ipinfodb.com/my_ip_location.php | awk '/Zip or postal code : /{print $6}' | awk '{gsub(//,"")}; 1' | sed "s#</li>##"`

echo $zipcode

curl --silent "http://weather.yahooapis.com/forecastrss?p=$zipcode&u=f" | 
grep -E '(Current Conditions:|F<BR)' | 
sed -e 's/Current Conditions://' -e 's/<br \/>//' -e 's/<b>//' -e 's/<\/b>//' -e 's/<BR \/>//' -e 's///' -e 's/<\/description>//'

