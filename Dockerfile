# Create a docker base image with a few essentials
FROM ubuntu:trusty
MAINTAINER Ilkka Anttonen version: 0.8

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install and setup useful base packages
RUN apt-get install -y curl lsb-release supervisor openssh-server rsyslog git net-tools joe iputils-ping unzip dnsutils
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN locale-gen en_US en_US.UTF-8
# Set the root account password
RUN echo 'root:root' | chpasswd

# Allow root login with a password
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# It seems for now we have to disable PAM for SSH logins to work
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Install Consul
RUN wget https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip -O /tmp/consul.zip
RUN unzip /tmp/consul.zip -d /usr/local/bin
RUN chmod oug+rx /usr/local/bin/consul

# Set up the Consul configuration
RUN mkdir /etc/consul.d
