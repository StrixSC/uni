FROM ubuntu:latest

RUN apt-get update &&\
    apt-get install -y nano software-properties-common &&\
    add-apt-repository ppa:gluster/glusterfs-6 &&\
    apt-get update &&\
    apt-get install -y glusterfs-server
    
EXPOSE 24007
EXPOSE 49152-49160
