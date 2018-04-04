FROM anapsix/alpine-java:8_jdk as builder

LABEL maintainer="https://jbake.org/community/team.html"

# Define environment variables.
ENV BUILD_DATE=03042018
ENV JBAKE_HOME=/opt/jbake

RUN mkdir ${JBAKE_HOME} 

COPY jbake /usr/src/jbake

RUN cd /usr/src/jbake && ./gradlew installDist && cp -r jbake-dist/build/install/jbake/* $JBAKE_HOME && \
    rm -r ~/.gradle /usr/src/jbake

###############
# Image Stage #
FROM anapsix/alpine-java:8

ENV JBAKE_USER=jbake
ENV JBAKE_HOME=/opt/jbake
ENV PATH ${JBAKE_HOME}/bin:$PATH

RUN adduser -D -g "" ${JBAKE_USER} ${JBAKE_USER}

USER ${JBAKE_USER}

COPY --from=builder /opt/jbake /opt/jbake

WORKDIR /mnt/site

# Define mount points.
VOLUME ["/mnt/site"]

ENTRYPOINT ["jbake"]
CMD ["-b","-s"]

#Expose default port
EXPOSE 8820
