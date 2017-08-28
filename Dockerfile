FROM clojure:lein-2.6.1-alpine

MAINTAINER Ray McDermott "ray.mcdermott@vdartdigital.com"

RUN apk add --no-cache unzip curl

ENV DATOMIC_VERSION=0.9.5561.56
ENV DATOMIC_HOME /opt/datomic-pro-${DATOMIC_VERSION}
ENV DATOMIC_DATA $DATOMIC_HOME/data
ENV DATOMIC_URL https://my.datomic.com/repo/com/datomic/datomic-pro/$DATOMIC_VERSION/datomic-pro-$DATOMIC_VERSION.zip

RUN mkdir -p /opt/datomic-wrapper
ADD transactor-wrapper.sh /opt/datomic-wrapper
ADD datomic-postgres-setup.sh /opt/datomic-wrapper

# NOTE: .credentials should be kept outside of version control, especially public repos
ONBUILD ADD .credentials /tmp/.credentials

ONBUILD RUN curl -u $(cat /tmp/.credentials) -SL $DATOMIC_URL -o /tmp/datomic.zip \
            && unzip -q /tmp/datomic.zip -d /opt    \
            && rm -f /tmp/datomic.zip               \
            && rm -f /tmp/.credentials

WORKDIR $DATOMIC_HOME

# Use Docker volumes to add a configuration file (more in README) and mount it on your Dockerfile
#
# CMD ["/opt/datomic-pro/config/tx.config"]

ENTRYPOINT ["./transactor-wrapper.sh"]

# This VOLUME is to enable data to persist across executions for cases where
# have Datomic data on a local disk (for example 'dev' storage).
# Where an external DB storage service is used this volume is not used / needed.

VOLUME $DATOMIC_DATA

EXPOSE 4334 4335 4336