FROM ubuntu:18.04

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 17
    apt-get install -qy openjdk-17-jdk && \
# Install required dependencies
    apt-get install -qy wget tar && \
# Download and install Maven 3.9.6
    wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar -xvzf /tmp/maven.tar.gz -C /opt && \
    mv /opt/apache-maven-3.9.6 /opt/maven && \
    rm /tmp/maven.tar.gz && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:password" | chpasswd && \
    mkdir /home/jenkins/.m2

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

# Set correct ownership
RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Add Maven binary to the system path
RUN ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Standard SSH port
EXPOSE 22

# Verify Java and Maven installation
RUN java -version && mvn -version

CMD ["/usr/sbin/sshd", "-D"]
