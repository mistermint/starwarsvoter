#!/bin/bash
sudo service tor start
while true; do
	echo "Restarting Tor..."
	sleep 2s
	sudo service tor reload
	sleep 1s
	echo "Restarted Tor"
	for i in 1 2 3 4 5; do
		echo "Attempting vote $i..."
		RESULT=`curl --socks5 127.0.0.1:9050 'https://voting.playbuzz.com/poll/' \
			-H 'authority: voting.playbuzz.com' \
			-H 'accept: application/x-www-form-urlencoded' \
			-H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36' \
			-H 'content-type: application/x-www-form-urlencoded' \
			-H 'origin: https://editorial.rottentomatoes.com' \
			-H 'sec-fetch-site: cross-site' \
			-H 'sec-fetch-mode: cors' \
			-H 'sec-fetch-dest: empty' \
			-H 'referer: https://editorial.rottentomatoes.com/article/summer-movie-showdown/' \
			-H 'accept-language: en-US,en;q=0.9' \
			--data 'sectionId=bdf86fe5-6cad-43a7-af64-f9614390b1a8&questionId=5c70474a-d2eb-417e-b14b-478a3bf6cb75&resultId=973abd80-01aa-4563-bbf6-a58c827e402d' \
			--compressed -s`
		if [ -z "$RESULT" ]
		then
			echo "Request failed, refreshing IP..."
			break
		else
			echo "Request success: $RESULT"
		fi
	done
done
