FROM alpine

RUN apk add --no-cache bash hostapd iptables iproute2 iw dnsmasq
RUN echo "" > /var/lib/dhcp/dhcpd.leases
ADD wlanstart.sh /bin/wlanstart.sh

ENTRYPOINT [ "/bin/wlanstart.sh" ]
