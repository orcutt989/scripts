#!/bin/bash
yum install jq -y
cd ~ || exit
curl -s https://api.github.com/repos/jagrosh/musicbot/releases/latest | grep "browser_download_url.*jar" | cut -d : -f 2,3 | tr -d \" | wget -qi -

FILENAME=$(ls)

SECRET_NAMES=(
"jmusicbot_discord_bot_token"
"discord_id_owner"
)

EC2_REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`

for SECRET_NAME in "${SECRET_NAME[@]}"
do
  SECRET=$(aws secretsmanager get-secret-value --region "${EC2_REGION}" --secret-id "${SECRET_NAME}" --query SecretString --output text | jq -r ."${SECRET_NAME}")
  echo "${SECRET_NAME##*_*_} = ${SECRET}" >> config.txt
done

echo "prefix = \"-\"" >> config.txt

nohup java -Dnogui=true -jar "${filename}" &

