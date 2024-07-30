FROM nginx:1.25

# Update the package list and install dnsutils
RUN apt-get update && \
    apt-get install -y dnsutils procps && \
    rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 80
EXPOSE 443

# Set the default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
