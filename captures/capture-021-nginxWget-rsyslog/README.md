#### Anthos:
#### Modified from https://github.com/detlearsom/DetGen/tree/main
#### note for submission: the "conf" folder was skipped because of its large size, please access it from https://github.com/detlearsom/DetGen/tree/main
Capture method: Rsyslog
Log redirection method: Logger through capture script

Usage: sudo ./capture.sh DURATION REPEAT

This scenario runs wget in recursive mode https://www.gnu.org/software/wget/manual/html_node/Recursive-Retrieval-Options.html

## Configuration

To configure the server, edit the `nginx.conf` file

## Website

To add your own static website, (download it using wget) put all the files in the `conf` folder. Then the homepage of that webpage must be renamed to `index.html`. 
The current setting uses the www.templated.co website.
