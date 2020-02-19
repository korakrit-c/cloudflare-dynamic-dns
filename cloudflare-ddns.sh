#/usr/bin/env sh

# Main script to edit the record, should be used with cron

# Variables:
#   CLOUDFLARE_API_TOKEN   - Cloudflare API token from Cloudflare dashboard (Authentication tab)
#   CLOUDFLARE_ZONE_ID     - Zone ID from cloudflare-get-zones.sh script
#   CLOUDFLARE_RECORD_NAME - Subdomain without the root domain, e.g. dynamic
#   CLOUDFLARE_RECORD_ID   - DNS record ID from cloudflare-get-dns-id.sh script

CLOUDFLARE_API_TOKEN=
CLOUDFLARE_ZONE_ID=
CLOUDFLARE_RECORD_NAME=
CLOUDFLARE_RECORD_ID=

# Retrieve the last recorded public IP address
IP_RECORD="/tmp/cloudflare-dunamic-dns-ip-record"
RECORDED_IP=`cat $IP_RECORD`

# Fetch the current public IP address
PUBLIC_IP=$(curl --silent https://api.ipify.org) || exit 1

#If the public ip has not changed, nothing needs to be done, exit.
if [ "$PUBLIC_IP" = "$RECORDED_IP" ]; then
  exit 0
fi

# Otherwise, your Internet provider changed your public IP again.
# Record the new public IP address locally
echo $PUBLIC_IP > $IP_RECORD

# Record the new public IP address on Cloudflare using API v4
RECORD=$(cat <<EOF
  { "type": "A",
  "name": "$CLOUDFLARE_RECORD_NAME",
  "content": "$PUBLIC_IP",
  "ttl": 1,
  "proxied": false }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$CLOUDFLARE_RECORD_ID" \
  -X PUT \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$RECORD"
