FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      shellinabox \
      openssh-server \
      sudo \
      vim \
      nano \
      curl \
      wget \
      ca-certificates \
      net-tools \
      iproute2 \
      locales \
      tzdata \
      procps \
      dbus-x11 \
      xrdp \
      xfce4 \
      xfce4-terminal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /run/sshd /workspace && \
    printf '\nPermitRootLogin yes\nPasswordAuthentication yes\n' >> /etc/ssh/sshd_config && \
    echo "startxfce4" > /root/.xsession && \
    chmod +x /root/.xsession && \
    adduser xrdp ssl-cert

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 3389 4200

CMD ["/entrypoint.sh"]
