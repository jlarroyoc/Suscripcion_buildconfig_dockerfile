# Pull official base image
FROM registry.access.redhat.com/ubi8/python-38

RUN echo 'WHOAMI' && whoami 
USER root

# Set work directory
WORKDIR /opt/app-root/src

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Certificate error workaround
#RUN rm -rf /etc/rhsm-host

# Install dependencies
RUN dnf -y update
RUN dnf -y upgrade gzip
RUN dnf -y install wget unzip libaio tzdata postgresql-devel gcc libtool python38-devel diffutils libxml2-devel cairo libnsl*
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf -y update
#RUN dnf -y install bison byacc flex redis

RUN mkdir /opt/oracle
ENV TZ Europe/Madrid

# Copy project
COPY . .

RUN chgrp -R 0 . && \
chmod -R g=u .

RUN echo 'WHOAMI' && whoami 

# Install KampalGraph library
RUN cd igraph-release-0.7 && ./bootstrap.sh

RUN pwd

# Launch services (web and background workers)
CMD ./launch_services.sh
