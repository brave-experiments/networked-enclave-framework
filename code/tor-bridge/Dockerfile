FROM debian:stable-slim

RUN apt-get install tor -y

COPY torrc /
COPY start.sh /
COPY nitriding /

CMD ["/start.sh"]
