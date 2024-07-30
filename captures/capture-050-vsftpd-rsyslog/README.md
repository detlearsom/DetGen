### Anthos:
### Modified from https://github.com/detlearsom/DetGen/tree/main
Capture method: Rsyslog
Log redirection method: Logger through capture script

Usage: sudo ./capture-vsftpd.sh ACTIVITY DURATION REPEAT

This scenario contains a client using a Vsftp server https://security.appspot.com/vsftpd.html#docs 

## Configuration

To configure the server, edit the `config/httpd.conf` and `config/httpd-ssl.conf` file

## The different activities
In general all the activities copy their needed files into the `user` directory where they become accessible for the server. Then the client connets to that server and issues some commands. If the client requests a file it can be found in the `receive` folder. Finally, all files from the `user` folder are deleted.
1. Get only a single specified file (get)
2. Get all the files in the directory (mget)
3. Remove a single file (delete)
4. Remove all files (mdelete)
5. Make a directory, change into it and put a file in it (mkdir -> cd -> put)
6. Make a directory, move a file into it (mkdir -> rename)
7. Just put a file in the directory (put)
8. Put a file and then request it (put -> get)
9. Send multiple files (mput)
10. Make a directory, put files in it and then remove directory (mkdir -> cd -> mput -> mdelete -> cd -> chmod -> rmdir). Note: to `rmdir` the directory must be empty and that is why there are more steps here. Also the `chmod` operation here is not required but I decided to add it anyways.

