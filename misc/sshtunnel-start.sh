#!/bin/bash
### Start the ssh tunnel, if it is not already up.

SSH=2221
HTTP=50375
HTTPS=8236
USER=sshtunnel
HOST=test1.fs.al
KEYFILE=$0

### The command to open the tunnel connection.
COMMAND="ssh -qfNT -p $SSH -i $KEYFILE -R $HTTP:localhost:80 -R $HTTPS:localhost:443 $USER@$HOST"

### The command to test the tunnel (by looking at "netstat" output on $REMOTE_HOST)
TEST_TUNNEL="ssh -p $SSH -i $KEYFILE $USER@$HOST > /dev/null 2>&1"

### Setup a cron job to monitor the sshtunnel.
if [ ! -f /etc/cron.d/sshtunnel ]; then
    script=$(readlink -f $0)
    cat <<EOF > /etc/cron.d/sshtunnel
* * * * * root $script >/dev/null 2>&1
EOF
    chmod +x /etc/cron.d/sshtunnel
fi

### Is the tunnel up? Perform two tests:
### 1. Check for relevant process ($COMMAND)
### 2. Test tunnel by looking at "netstat" output on $REMOTE_HOST
pgrep -f -x "$COMMAND" > /dev/null 2>&1 || $COMMAND
$TEST_TUNNEL
if [ $? -ne 0 ] ; then
   pkill -f -x "$COMMAND"
   $COMMAND
fi

exit 0

-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxzNU8LRi/69eH2sA/cCN9rj3MkKOkq7lDzcKYP2H0w7/kIP2
4461+OQ2lXSg66eCGK3NEjKwgp03VOX2jyRGkvNKSnO0WWcffjU6gf1/tW+9QVAv
6EZvyzgVKzQxLfPhFpWWESQfRCqVWYfLNOsrpJlO8mxdoaVqW7pIkN78uJzOovYh
ZscrhPoJmU09lO6RxSiI583Aei6zGVyr0jj8K2n8KTWmlthuAc8+uot/it7tJK0e
IUhYO5QpVpn3ck3PMOU7o4O2DrTQ9lB52p3sFIWHn/SC8O9NEhAWeZhqzgZA31dV
KfAbzSGwEuB2/n0HKIbc/i9KTBFspR8OIeQugwIDAQABAoIBAFwSqewoNKoiEMtM
1kRzwCqODBQ7F1NNa6rAshdqmGFByXauyGseB5ZnRaOHKOpDnqpxixwiOdvldzHS
qUg4aDZ8JZaMLIw2UiQvzj9PQLxITZ3mxn4CMKIp5f72PNUUqLGbqqV5oMoNNMMR
NSfcm2uVQRxkYlLY9nQ3glsT9pQNdVcfGmky34iwyXMM0srVGo/hlauLVwlWxQUm
KCN9QmcN1pcB1eXOSnpC/jWxDqeq2zboooACBhrpgJQMYjTw+jReZMQj6c2wZC3s
CgAilq60aNm7vDEihqk1bpDd7yG8r3vIrHBVNYLufDGfq8Vfl8KwNNzQWWh/0r3I
6lW5kYECgYEA8sltY4KvmjICA1nYiSgPNBsxONdai/IHVpnqSYEt1oLkeWzUjX2m
462IR2OUOV3kDEUwJdJ0XTYJ9metel7aALedXkyj+P+1fEvevW6ceefUYPcK8qLN
6MuyqOfovUyhV8dCMEn1cQh1axtDmImPYfcsVgJksF5dZ2iDNyAoGvECgYEA0gql
5uSfQIBu1BVq/MT3qM11l6+gPpmMNqNApaQOGxvTcxPLKxXYZWBd4apVYeOcpDaR
v2jrqNXhC+j3Uhl591TvoDMjGBR9KxnLN3fVCYFpyzwgCjrfcPQm7/d3frka77c7
X/TSj0AXrE5bEvItuomvPqI7ywn8rB1xr1T+2LMCgYEA6sy8+vEHjPNyGPWKQdM5
KOZnaxZynkdaq3k9KQtCXmPGPFxxD8mGXkiUNJ5sWjKgevFqyBlJql+5sNDB6EfV
Q75P9kPejNAYH3Zsmv1fXVJEheZFczTaOJrPVSS7ZF+45eBx9auBMGjCzevXKq1W
uqLGAQRdhmgsovZjeCukPbECgYAB/lPgwx630AA9Rw7C42OuWHTbQbF1pqNsCVSd
vdbcbwEswG1XNVfebnG1qJYy3aQo8tOjS22hJpaCNG3Ue6VqsYWssY+NtPQTKqWB
G0QMWQwV/7YWIsToH4kXEfQyYbNdvxFzMbGl5mfTHNNEdMP2V0Qwhf2nSar6PzVL
ArWAfQKBgQDyDvyjNsM+oYhp3IJGXbhLX7iFRiNl2g2T1MV1A8WQdpqBYDbiCj83
IXN+Tm5rot7qzo6pTYX7MZLWxoyUHrYENu/XRAOnuTYYNeJTrYCBP3C6FBNanZaV
9GWOtZWgBdbvIpxd/M2hfrqzzE7+0WI6vnCJaWGgeHc9CR7g+K2+1A==
-----END RSA PRIVATE KEY-----

