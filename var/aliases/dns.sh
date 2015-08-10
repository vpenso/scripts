
export DOMAIN=$(hostname -d)
 
alias host-ip="dig +short +domain=$DOMAIN" 
