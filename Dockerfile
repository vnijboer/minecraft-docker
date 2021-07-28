FROM ubuntu:latest

ARG downloadPath=https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
#Default downloading version 1.15.2

ARG minecraftRam=1024M
ARG DEBIAN_FRONTEND=noninteractive

EXPOSE 25565

WORKDIR /

USER root

# create directory
RUN mkdir -p /minecraft/server


# copy files
COPY stop.sh /minecraft/server/
COPY server.properties /minecraft/server


RUN apt-get update


#Install java, git, wget, gcc
RUN apt-get install default-jre git wget gcc dos2unix -y

# mcrcon installation

RUN git clone  git://git.code.sf.net/p/mcrcon/code /mcrcon-code


RUN gcc /mcrcon-code/mcrcon.c -o /minecraft/server/mcrcon 

# /minecraft/server/mcrcon -H localhost -P 8308 -p lDGg@yz@TNC -t

WORKDIR /minecraft/server

#download jar file
RUN wget ${downloadPath}

RUN echo "eula=true" > eula.txt

RUN echo "/usr/bin/java -Xmx${minecraftRam} -Xms${minecraftRam} -jar /minecraft/server/server.jar --nogui" > start.sh

RUN dos2unix eula.txt
RUN dos2unix stop.sh
RUN dos2unix start.sh



CMD ["/bin/bash", "-ex", "start.sh"]

ENTRYPOINT ["/bin/bash", "-ex", "stop.sh"]
