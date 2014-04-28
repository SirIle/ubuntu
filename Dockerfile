# Create a docker base image with a few essentials
FROM stackbrew/ubuntu:trusty
MAINTAINER Ilkka Anttonen version: 0.4

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Disable IPv6 for apt for now because we use an internal DNS server
#RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf

# Install and setup useful base packages
RUN apt-get install -y curl lsb-release supervisor openssh-server rsyslog git net-tools joe iputils-ping
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
