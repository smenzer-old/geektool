echo
echo `cal` | 
sed -E '1,$'"s/ ($(date +%e))( |$)/ `printf '\033[1;31m'`\1`printf '\033[0m'`\2/" | 
sed s'/Su Mo Tu We Th Fr Sa//g' | 
sed s'/  */  \|  /g' | 
sed s'/^  \|//' | 
sed s'/  \|//' | 
sed s'/\|/  /' | 
sed s"/\|/`printf '\033[1;31m.\033[0m'`/g" | sed s"/$/       $(date +%A)/"
