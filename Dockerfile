# Bamboo Server
#
# VERSION               0.0.1

FROM hwuethrich/supervisord
MAINTAINER Florian Pfeiffer "fpfeiffer-github@x8s.de"

# Environment
ENV BAMBOO_VERSION 5.4
ENV BAMBOO_HOME /home/bamboo

# Add startup script and supervisor config
ADD bamboo-server.sh /start/bamboo-server
ADD supervisor.conf /etc/supervisor/conf.d/bamboo-server.conf

# Install Oracle Java 7
RUN eatmydata -- apt-get install -yq python-software-properties && add-apt-repository ppa:webupd8team/java -y && apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN eatmydata -- apt-get install -yq oracle-java7-installer

# VCS tools
RUN eatmydata -- apt-get install -yq git subversion

# Maven3 - Bamboo doesn't work with the one ubuntu provides *sigh*
RUN eatmydata -- mkdir /opt ; cd /opt ; wget http://www.gtlib.gatech.edu/pub/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz && tar xzf apache-maven-3.2.3-bin.tar.gz && rm apache-maven-3.2.3-bin.tar.gz

# Expose web and agent ports
EXPOSE 8085
EXPOSE 54663

# Run supervisord
CMD ["/start/supervisord"]

