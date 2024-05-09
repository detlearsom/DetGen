FROM mysql/mysql-server:8.0.23

# Switch to root user for installation
#USER root

# Install util-linux
RUN yum --disablerepo=mysql80-server-minimal install -y util-linux && yum clean all


# Switch back to mysql user
#USER mysql

# Expose MySQL port
EXPOSE 3306


