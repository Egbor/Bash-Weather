#!/bin/bash

basename=$(basename $0)
file_config="config.ini"
file_weather="/tmp/weather"

delay=$(cat $file_config | grep "delay" | sed 's/delay[ ]*=[ ]*//')
start_time=$(date +%s)
current_time=$((start_time + delay))

while :
do
	if [[ $((current_time - start_time)) -ge $delay ]]
	then
		wget -O $file_weather https://weather.com/ru-BY/weather/today/l/e43b54e3c12c4e51cf215f13c1deb2ee7f0cf851766163d37ae8d95c16b80ce2 &> /dev/null

		if [[ $? -eq 0 ]]
		then
			temp_value=$(cat $file_weather | grep -E 'class="CurrentConditions--tempValue--3a50n"' | sed 's/.*<span data-testid="TemperatureValue" class="CurrentConditions--tempValue--3a50n">//' | sed 's/<\/span>.*//')
			phrase_value=$(cat $file_weather | grep -E 'class="CurrentConditions--phraseValue--2Z18W"' | sed 's/.*<div data-testid="wxPhrase" class="CurrentConditions--phraseValue--2Z18W">//' | sed 's/<\/div>.*//')
			
			echo "$temp_value $phrase_value"

			start_time=$current_time
		else
			echo "$basename: check network connection"
		fi
	fi
	current_time=$(date +%s)
done

