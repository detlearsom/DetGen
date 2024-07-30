# Use an official Kali Linux base image
FROM kalilinux/kali-rolling

# Update and install necessary dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y metasploit-framework

# Set the working directory
WORKDIR /root

# Expose the necessary ports (e.g., for msfconsole)
EXPOSE 4444

