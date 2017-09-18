#!/bin/bash

printf "\n" >> ticker_diff_latest.csv
date >> ticker_diff_latest.csv
printf "new< >gone\n" >> ticker_diff_latest.csv

cp ticker_final.csv ticker_old.csv

curl https://api.coinmarketcap.com/v1/ticker/ | grep "symbol" | awk '{print $2}' > ticker_symbol.csv
curl https://api.coinmarketcap.com/v1/ticker/ | grep "id\":" | awk '{print $2}' > ticker_name.csv

paste -d'\0' ticker_symbol.csv ticker_name.csv > ticker_final.csv

rm -f ticker_symbol.csv
rm -f ticker_name.csv

sort ticker_final.csv > ticker_final_sorted.csv
sort ticker_old.csv > ticker_old_sorted.csv

sdiff -s ticker_final_sorted.csv ticker_old_sorted.csv >> ticker_diff_latest.csv

cp ticker_diff_latest.csv z_ticker_diff_backup_`date +%Y%m%d`.csv

rm -f ticker_old.csv
rm -f ticker_old_sorted.csv
rm -f ticker_final_sorted.csv