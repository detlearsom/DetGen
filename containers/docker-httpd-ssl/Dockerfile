FROM httpd:2.4

# install snakeoil certificates
RUN apt update && apt install -y ssl-cert procps

# enable https on port 443 with snakeoil certificates
RUN sed -i \
   -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
   -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
   -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
   conf/httpd.conf
RUN sed -i \
   -e 's|^\(SSLCertificateFile\).*|\1 /etc/ssl/certs/ssl-cert-snakeoil.pem|' \
   -e 's|^\(SSLCertificateKeyFile\).*|\1 /etc/ssl/private/ssl-cert-snakeoil.key|' \
   conf/extra/httpd-ssl.conf

# additionally expose port 443
EXPOSE 443
