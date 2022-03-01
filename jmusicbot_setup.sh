#!/bin/bash
yum install jq -y
cd ~ || exit
curl -s https://api.github.com/repos/jagrosh/musicbot/releases/latest | grep "browser_download_url.*jar" | cut -d : -f 2,3 | tr -d \" | wget -qi -

filename=$(ls)

vars=(
"jmusicbot_discord_bot_token"
"discord_id_owner"
)

for var in "${vars[@]}"
do
  secret=$(aws secretsmanager get-secret-value --region us-east-2 --secret-id "${var}" --query SecretString --output text | jq -r ."${var}")
  echo "${var##*_*_} = ${secret}" >> config.txt
done

echo "prefix = \"-\"" >> config.txt

nohup java -Dnogui=true -jar "${filename}" &

