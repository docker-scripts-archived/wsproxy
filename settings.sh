APP=wsproxy

### Docker settings.
IMAGE=wsproxy
CONTAINER=wsproxy
PORT_SSH=2222    ## ssh port is needed for websites that are accessed through ssh-tunnels
PORTS="80:80 443:443 $PORT_SSH:22"

### Gmail account for notifications. This will be used by ssmtp.
### You need to create an application specific password for your account:
### https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882
GMAIL_ADDRESS=
GMAIL_PASSWD=
