#!/bin/bash
if [ $# -ne 1 ]; then
    echo "usage: $(basename $0) <storage>"
    exit 1
fi

wget http://s3.amazonaws.com/mbrainz/datomic-mbrainz-1968-1973-backup-2014-11-17.tar -O /data/mbrainz.tar
tar -xvf /data/mbrainz.tar -C /data
$DATOMIC_HOME/bin/datomic restore-db \
                          file:///data/mbrainz-1968-1973 \
                          datomic:$1://localhost:4334/mbrainz-1968-1973
