SRC=/usr/local/src/wsproxy

IMAGE=wsproxy
CONTAINER=wsproxy
PORT_SSH=2222
PORTS="80:80 443:443 $PORT_SSH:22"

CONFIG="set_prompt ssmtp apache2"
GMAIL_ADDRESS=user@gmail.com
GMAIL_PASSWD=xyz
