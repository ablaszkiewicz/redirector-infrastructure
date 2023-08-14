#!/bin/sh
domain="asddaff.bieda.it"
out="/etc/nginx/conf.d/default.conf"
config_file="config" 
frontend_path="http://192.168.1.103:4003"
backend_path="http://192.168.1.103:4001"

output_variable=$(cat "$config_file" | tr '\n' '|')
output_variable=${output_variable%|}

# remove the contents of the original nginx config file
echo -n > "$out"

# rewrite /nginx/(.*) /$1  break;
config=$(cat <<EOF
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location ~ ^/($output_variable)/* {
        proxy_pass $frontend_path;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_ssl_name \$host;
        proxy_ssl_server_name on;
        proxy_ssl_verify off;
        proxy_ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_session_reuse off;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 120;
        proxy_send_timeout 120;
        proxy_connect_timeout 120;
    }

    location = / {
        proxy_pass $frontend_path;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_ssl_name \$host;
        proxy_ssl_server_name on;
        proxy_ssl_verify off;
        proxy_ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_session_reuse off;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 120;
        proxy_send_timeout 120;
        proxy_connect_timeout 120;
    }

    location / {
        proxy_pass $backend_path;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_ssl_name \$host;
        proxy_ssl_server_name on;
        proxy_ssl_verify off;
        proxy_ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_session_reuse off;
        proxy_set_header X-Forwarded-For \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 120;
        proxy_send_timeout 120;
        proxy_connect_timeout 120;
    }
}
EOF
)

# append the new config to the end of the nginx config file
echo "$config" >> "$out"