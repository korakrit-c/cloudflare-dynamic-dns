# cloudflare-dyanmic-dns

Cloudflare DDNS curl scripts that calls CF-API (v4) directly

## Setup

Instructions and descriptions of variables can be found at the top of each shell script.

1) Run `cloudflare-get-zones.sh` to get the zone ID of your domain
2) Run `cloudflare-get-dns-id.sh` to get the record ID for the subdomain
3) Put `Record Name` and `Record Key` into `cf_record.txt`
4) Run it as a test and then set up with cron as `* * * * * ./cloudflare-ddns.sh` (run every minute, will only make request to Cloudflare is IP is different to one cached)

## Crontab for Raspberry Pi
Run `crontab -e` to open up the crontab editor

add the following line

`* * * * * /usr/bin/sudo -H /usr/local/bin/cloudflare-ddns.sh >> /dev/null 2>&1`
