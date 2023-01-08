# Docker image to provide XML tooling required in the CI/CD pipeline
# Currently, the foloowing is installed: 
# - Saxon HE for XSLT transformations
# - XMLStarlet for validating the XML schema

FROM openjdk:21-slim

LABEL maintainer="vrbj04@vse.cz"

RUN apt update
RUN apt install -y unzip
RUN apt install -y fop

RUN mkdir -p /opt/saxon
RUN mkdir -p /opt/crux

ADD https://netix.dl.sourceforge.net/project/saxon/Saxon-HE/11/Java/SaxonHE11-4J.zip /tmp/saxon.zip
ADD https://github.com/NCAR/crux/releases/download/v1.3/crux-1.3-all.jar /opt/crux/crux.jar

RUN unzip -q /tmp/saxon.zip -d /opt/saxon
