#!/bin/bash
  
RED='\033[0;31m'
RESET='\033[0m'
while true
do
        source $HOME/.profile
        cd $HOME/massa/massa-client
        wallet_info=$(./massa-client --pwd $massa_pass wallet_info)
        addresses_string=$(echo "$wallet_info" | grep Address | awk '{ print $2 }')
        final_rolls_string=$(echo "$wallet_info" | grep "Rolls" | awk '{ print $3 }' | sed 's/final=//;s/,//')
        declare -a addresses_array
        readarray -t addresses_array <<< "$addresses_string"
        declare -a final_rolls_array
        readarray -t final_rolls_array <<< "$final_rolls_string"
        length=${#addresses_array[@]}
        for ((i=0; i<$length; i++)); do
                address=${addresses_array[$i]}
                rolls=${final_rolls_array[$i]}
                echo "Final rolls for ${address}: ${rolls}"
                int_rolls=${rolls%%.*}
                if [ "$int_rolls" -lt "1" ]; then
                        echo -e "${RED}-----------------------------------------------------------------------${RESET}"
                        echo -e "${RED}Buying rolls for ${address}${RESET}"
                        response=$(./massa-client --pwd $massa_pass buy_rolls $address 1 0)
                        echo $response
                        echo -e "${RED}-----------------------------------------------------------------------${RESET}"
                fi
        done
        date=$(date +"%H:%M")
        echo Last Update: ${date}
        printf "sleep"
        for((m=0; m<5; m++))
        do
                printf "."
                sleep 1m
        done
        printf "\n"
done
