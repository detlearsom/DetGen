#### Anthos:
#### Modified from https://github.com/detlearsom/DetGen/tree/main
Capture method: Rsyslog
Log redirection method: Logger through capture script

Usage: sudo ./capture-apache.sh DURATION REPEAT

This scenario uses 2 clients using wget over HTTP and HTTPS https://www.gnu.org/software/wget/manual/html_node/index.html

#### Configuration

To configure the server, edit the `config/httpd.conf` and `config/httpd-ssl.conf` file

Self-signed certificates in `config/ssl` may need to be recreated.
