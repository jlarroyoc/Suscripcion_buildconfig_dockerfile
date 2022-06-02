# Pull official base image
FROM registry.access.redhat.com/ubi8/python-38:latest

USER root

# Set work directory
WORKDIR /opt/app-root/src

COPY ./entitlement /etc/pki/entitlement

# AST: Recomendación RH para asegura que el grupo root (al que pertenece el usuario con el que ejecutar el contenedor) tenga acceso a los ficheros oportunos
RUN chgrp -R 0 /opt/app-root/src && \
   chmod -R g=u /opt/app-root/src

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Certificate error workaround
RUN rm -rf /etc/rhsm-host

# AST: Recomendación RH agrupar en una unica instruccion RUN y hacer un borrado de la cache tras instalar los paquetes
RUN dnf -y update && \
 dnf -y upgrade gzip && \
 dnf -y install wget unzip libaio tzdata postgresql-devel gcc libtool python38-devel diffutils libxml2-devel cairo libnsl* && \
 dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
 dnf -y update && \
 dnf -y install bison byacc flex redis && \
 dnf clean all -y

RUN mkdir /opt/oracle
# AST: Recomendación RH para asegurar que el grupo root (al que pertenece el usuario con el que ejecutar el contenedor) tenga acceso a los ficheros oportunos
RUN chgrp -R 0 /opt/oracle && \
   chmod -R g=u /opt/oracle

ENV TZ Europe/Madrid

# Copy project
COPY . .

# Install Oracle Client
RUN cp -r oracle/instantclient_19_12 /opt/oracle

# Install KampalGraph library
# AST: dar permisos de ejecución a bootstrap.sh
RUN cd igraph-release-0.7

# Launch services (web and background workers)
CMD sleep 3000
