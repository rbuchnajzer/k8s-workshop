FROM ubuntu:18.04

RUN apt-get update -y && apt-get install openssh-client curl vim -y
RUN curl -sL https://github.com/digitalocean/doctl/releases/download/v1.8.3/doctl-1.8.3-linux-amd64.tar.gz | tar -xzv
RUN mv /doctl /usr/local/bin/doctl
ADD scripts /root/install/digitalocean
WORKDIR /root/install/digitalocean

CMD /bin/bash