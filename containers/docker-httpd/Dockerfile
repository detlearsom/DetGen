FROM httpd:2.4

RUN apt update && apt install procps -y

COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
