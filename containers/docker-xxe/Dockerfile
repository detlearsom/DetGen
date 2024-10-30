FROM php:apache-bookworm
COPY httpd-foreground /usr/bin/
RUN chmod 755 /usr/bin/httpd-foreground
CMD ["/usr/bin/httpd-foreground"]

EXPOSE 80
