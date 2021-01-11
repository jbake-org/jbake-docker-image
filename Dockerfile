FROM gradle:6.7.1-jdk8 as builder
WORKDIR /opt/jbake
RUN git clone https://github.com/jbake-org/jbake.git \
    && cd jbake \
    && ls \
    && git checkout v2.6.5 \
    && ./gradlew assemble \
    && tar xvf  jbake-dist/build/distributions/jbake-2.7.0-SNAPSHOT.tar  \
    && ls \
    && pwd


FROM openjdk:8-alpine

ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --no-create-home \
    --uid "${uid}" \
    "${user}"
 
COPY --from=builder /opt/jbake/jbake/jbake-2.7.0-SNAPSHOT/ /usr/local/lib/
RUN ls /usr/local/lib
WORKDIR /work
EXPOSE 8820
ENTRYPOINT ["sh", "/usr/local/lib/bin/jbake"]    

