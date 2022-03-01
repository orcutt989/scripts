#!/bin/bash
yum install jq -y
cd ~ || exit
curl -s https://api.github.com/repos/jagrosh/musicbot/releases/latest | grep "browser_download_url.*jar" | cut -d : -f 2,3 | tr -d \" | wget -qi -

filename=$(ls)

secret_names=(
"jmusicbot_discord_bot_token"
"discord_id_owner"
)

EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"

for secret_name in "${secret_names[@]}"
do
  secret=$(aws secretsmanager get-secret-value --region "${EC2_REGION}" --secret-id "${var}" --query SecretString --output text | jq -r ."${var}")
  echo "${secret_name##*_*_} = ${secret}" >> config.txt
done

echo "prefix = \"-\"" >> config.txt

nohup java -Dnogui=true -jar "${filename}" &

