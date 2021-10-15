FROM alpine:latest AS one
RUN \
  apk update && \
  apk upgrade && \
  apk add \
    shadow \
    dnsmasq \
    openrc
RUN \
  groupadd -g 2222 nonpriv && \
  useradd -u 2222 -g 2222 -s /bin/sh nonpriv   

COPY ./dnsmasq.conf /etc/dnsmasq.conf
COPY ./blacklists/* /etc/dnsmasq.d/

RUN chown -R nonpriv /etc/dnsmasq.d/ && chown nonpriv /etc/dnsmasq.conf && \
    chown -R nonpriv /etc/init.d/

USER nonpriv
EXPOSE 53 53/udp
STOPSIGNAL SIGQUIT
ENTRYPOINT ["dnsmasq", "-k"]

