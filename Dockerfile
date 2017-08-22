FROM clojure:lein-2.6.1-alpine

MAINTAINER Ray McDermott "ray.mcdermott@vdartdigital.com"

RUN apk add --no-cache unzip curl

ONBUILD ARG version=0.9.5561

ONBUILD RUN echo Downloading Datomic Pro version $version

ONBUILD ENV DATOMIC_HOME /opt/datomic-pro-$version
ONBUILD ENV DATOMIC_URL=https://my.datomic.com/repo/com/datomic/datomic-pro/$version/datomic-pro-$version.zip
ONBUILD ENV DATOMIC_DATA $DATOMIC_HOME/data


# Datomic Pro Starter as easy as 1-2-3
# 1. Create a .credentials file containing user:pass
# for downloading from my.datomic.com
ONBUILD ADD .credentials /tmp/.credentials

# 2. Make sure to have a config/ folder in the same folder as your
# Dockerfile containing the transactor property file you wish to use
ONBUILD RUN curl -u $(cat /tmp/.credentials) -sSL $DATOMIC_URL -o /tmp/datomic.zip \
            && unzip -q /tmp/datomic.zip -d /opt   \
            && rm -f /tmp/datomic.zip              \
            && rm -f /tmp/.credentials

ONBUILD ADD config $DATOMIC_HOME/config

ONBUILD WORKDIR $DATOMIC_HOME

# 3. Provide a CMD argument with the relative path to the
# transactor.properties file it will supplement the ENTRYPOINT

ENTRYPOINT ["./bin/transactor"]

ONBUILD VOLUME $DATOMIC_DATA

EXPOSE 4334 4335 4336
