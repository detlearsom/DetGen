FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y openssh-server \
                           sshpass \
                           rsyslog \
    && mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && echo "export VISIBLE=now" >> /etc/profile \
    && echo "auth.* @rsyslog:514" >> /etc/rsyslog.conf

ENV NOTVISIBLE "in users profile"
EXPOSE 22
CMD service rsyslog start && /usr/sbin/sshd -D
