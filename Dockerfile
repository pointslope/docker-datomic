FROM openjdk:8-jre-alpine

ENV DATOMIC_HOME /opt/datomic

RUN apk add --no-cache unzip curl bash

ONBUILD ADD .version /tmp/.version
ONBUILD ADD .credentials /tmp/.credentials
ONBUILD RUN export DATOMIC_VERSION=$(cat /tmp/.version) && curl -u $(cat /tmp/.credentials) -SL https://my.datomic.com/repo/com/datomic/datomic-pro/$DATOMIC_VERSION/datomic-pro-$DATOMIC_VERSION.zip -o /tmp/datomic.zip \
  && unzip /tmp/datomic.zip -d /opt \
  && rm -f /tmp/datomic.zip \
  && mv /opt/datomic-pro-$DATOMIC_VERSION/* $DATOMIC_HOME

ONBUILD ADD config $DATOMIC_HOME/config

WORKDIR $DATOMIC_HOME
RUN echo DATOMIC HOME: $DATOMIC_HOME
ENTRYPOINT ["./bin/transactor"]

EXPOSE 4334 4335 4336
