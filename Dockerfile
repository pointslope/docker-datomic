FROM pointslope/clojure:lein-2.5.0

MAINTAINER Christian Romney "cromney@pointslope.com"

ENV DATOMIC_VERSION 0.9.5130
ENV DATOMIC_HOME /opt/datomic-pro-$DATOMIC_VERSION
ENV DATOMIC_DATA $DATOMIC_HOME/data

# Datomic Pro Starter as easy as 1-2-3
# 1. Create a .credentials file containing user:pass
# for downloading from my.datomic.com
ONBUILD ADD .credentials /tmp/.credentials

# 2. Make sure to have a config/ folder in the same folder as your
# Dockerfile containing the transactor property file you wish to use
ONBUILD RUN curl -u $(cat /tmp/.credentials) -SL https://my.datomic.com/repo/com/datomic/datomic-pro/$DATOMIC_VERSION/datomic-pro-$DATOMIC_VERSION.zip -o /tmp/datomic.zip \
  && unzip /tmp/datomic.zip -d /opt \
  && rm -f /tmp/datomic.zip

ONBUILD ADD config $DATOMIC_HOME/config

WORKDIR $DATOMIC_HOME

# You can optionally load the mbrainz data
# later like so:
#
#   docker exec <container> /data/restore-mbrainz.sh <storage>
#
# where <container> is the name or id of a running Datomic Pro Starter container
# and <storage> is the storage type you are using e.g. dev
# 
# For more info see: https://github.com/Datomic/mbrainz-sample
ADD restore-mbrainz.sh /data/restore-mbrainz.sh

ENTRYPOINT ["bin/transactor"]

# 3. Provide a CMD argument with the relative path to the
# transactor.properties file it will supplement the ENTRYPOINT
VOLUME $DATOMIC_DATA

EXPOSE 4334 4335 4336
