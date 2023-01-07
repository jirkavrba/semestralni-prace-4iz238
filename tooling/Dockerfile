# Docker image to provide XML tooling required in the CI/CD pipeline
# Currently, the foloowing is installed: 
# - Saxon HE for XSLT transformations
# - XMLStarlet for validating the XML schema

FROM klakegg/saxon

# Download the latest xmlstarlet apk
RUN apk add xmlstarlet bash --update

# Remove the apk cache to keep the built docker image tiny
RUN rm -rf /var/cache/apk/*