# Docker image to provide XML tooling required in the CI/CD pipeline
# Currently, the foloowing is installed: 
# - Saxon HE for XSLT transformations
# - XMLStarlet for validating the XML schema

FROM openjdk:21-slim-buster

LABEL maintainer="vrbj04@vse.cz"

RUN apt update
RUN apt install -y unzip
RUN apt install -y xmlstarlet

ADD https://netix.dl.sourceforge.net/project/saxon/Saxon-HE/11/Java/SaxonHE11-4J.zip /tmp/saxon.zip

RUN mkdir -p /opt/saxon
RUN unzip -q /tmp/saxon.zip -d /opt/saxon
