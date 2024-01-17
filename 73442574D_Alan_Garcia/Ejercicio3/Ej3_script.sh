#! /bin/bash

# Iteramos por cada una de las líneas del fichero
while IFS= read -r line

do
  echo "$line"
  curl -XPUT "34.140.13.252:9200/logs" -H 'Content-Type: application/json' -d'$line'
  sleep 1
done < "./ej3_logs.txt"