# HOW THIS SIMULATION WORKS

## Data and running
The sample date used in this simulation is provided by `https://www.sample-videos.com` (which provides more than sample videos). The files that are used for sharing are in the `dataToShare` folder. They are being received in `receive` folder.
To run the simulation just run the capture script with the simulation number e.g. `./capture-vsftpd 5`

## Server
There are a number of quirks in those containers specifically the server side. Although in the `docker-compose.yml` file, the current directory is mounted, and hence that should be used, the container creates a folder with the username (in this case "user") which is actually where files for/from transfer are located. Therefore, the script, once docker is running, copies the files from `dataToShare` into the `user/` directory.

## Client
Then the client container needs to connect to the server. This is done by mounting CWD onto the client container and then running the script `inclient.sh` using `docker exec -ti`. The client then connects to the server and downloads the specified file in the `receive/` folder.

## The different scenarios
In general all the scenarios copy their needed files into the `user` directory where they become accessible for the server. Then the client connets to that server and issues some commands. If the client requests a file it can be found in the `receive` folder. Finally, all files from the `user` folder are deleted.
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

