# IRC chat

This capture includes an IRC chat server and two clients. There are two scenarios - the first one has the clients connect to the server, join a channel and send a message. The second one has them do the same and then client1 sends a file to client2.
To run just type `./capture-irc.ssh SCENARIO_NUMBER`.
NOTE: If you look at the logs from the client container you would notice they exit with error code 1. This does not prevent them from generating traffic. I think this might be because the "/QUIT" command is issued in the last place and the pseudo terminal in irc exits.

NOTE2: The second scripts is not working. The reason for that is that when trying to user the command "/DCC Send" the server issues a "DCC :Unknown command". If, however, I just have the server running and I have two irssi clients connected to the server and I issue the same command - files can be transferred with no issues.
