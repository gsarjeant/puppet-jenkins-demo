#!/bin/bash

# Doing this for speed.
# I'll handle it with a module if I finish the jenkins demo in time.

echo "Disabling the local firewall."
iptables -F
/sbin/service iptables save
