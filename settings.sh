APP=wsproxy

### Docker settings.
IMAGE=wsproxy
CONTAINER=wsproxy
PORT_SSH=2222    ## ssh port is needed for websites that are accessed through ssh-tunnels
PORTS="80:80 443:443 $PORT_SSH:22"

### Gmail account for server notifications (through ssmtp).
### Make sure to enable less-secure-apps:
### https://support.google.com/accounts/answer/6010255?hl=en
GMAIL_ADDRESS=
GMAIL_PASSWD=
