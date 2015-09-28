#!/bin/bash
### Daniel Korel Firewall Script ###

# My system IP/set ip address of server
SERVER_IP="<change for host IP>"

# Flushing all rules
iptables -F
iptables -X
iptables -F -t nat

# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow stated, related traffic
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Masquerading
#iptables -t nat -A PREROUTING -d $SERVER_IP -i eth0 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 6081
#iptables -A INPUT -p tcp -s 1.1.1.1 --dport 8081 -j ACCEPT
#iptables -t nat -A PREROUTING -d $SERVER_IP -p tcp --dport 80 -j DNAT --to-destination $SERVER_IP:8888

# Redirect public :80 to local varnish :6081
#iptables -t nat -A POSTROUTING -j MASQUERADE
#iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 6081

# Allow incoming ssh from ANYWHERE
iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 22 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming web on port 80 only from ANYWHERE
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 80 --dport 513:65535 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Port 443
iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 443 --dport 513:65535 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Port 5432
#iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 5432 -m state --state NEW -j ACCEPT
#iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 5432 --dport 513:65535 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#Allow incoming mysql on port 3306 FROM ANYWHERE
#iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 3306 -m state --state NEW -j ACCEPT
#iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 3306 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming ftp from ANYWHERE
#iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 20:21 -m state --state NEW -j ACCEPT
#iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 20:21 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 3000 -m state --state NEW -j ACCEPT
#iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 3000 -m state --state NEW -j ACCEPT
#iptables -A OUTPUT -p udp -s $SERVER_IP -d 0/0 --sport 3000 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p udp -s $SERVER_IP -d 0/0 --sport 3000 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT

#Allow incoming ICMP traffic from ANYWHERE
iptables -A INPUT -p icmp --icmp-type any -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type any -j ACCEPT
iptables -A OUTPUT -p udp --dport 33434:33523 -j ACCEPT

# Allow outgoing DNS requests. Few things will work without this.
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
