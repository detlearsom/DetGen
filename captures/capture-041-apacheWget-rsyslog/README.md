#### Anthos:
#### Based on https://github.com/detlearsom/DetGen/tree/main
#### Submission note: The "config" and "data" folders are missing due to the large size and should be accessed through https://github.com/detlearsom/DetGen/tree/main
Capture method: Rsyslog
Log redirection method: Logger through capture script

Usage: sudo ./capture.sh DURATION REPEAT


Server configuration is in "my-httpd.conf"

This scenario runs wget in recursive mode https://www.gnu.org/software/wget/manual/html_node/Recursive-Retrieval-Options.html

## Configuration

To configure the server, edit the `my-httpd.conf` file

## Website

To add your own static website, (download it using wget) put all the files in the `conf` folder. Then the homepage of that webpage must be renamed to `index.html`. 
The current setting uses the www.templated.co website.