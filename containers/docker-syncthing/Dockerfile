# Use the official Syncthing base image
FROM linuxserver/syncthing:1.27.2

# Install additional packages (in this case, we install util-linux for the logger command)
RUN apk --no-cache add util-linux

# Create a custom entrypoint script that includes the logger command
COPY init /init
RUN chmod +x /init

# Set the custom entrypoint script
ENTRYPOINT ["/init"]

