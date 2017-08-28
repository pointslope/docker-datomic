#!/usr/bin/env bash

set -e

# check if the configuration file is provided

if [ $# -ne 1 ]
then
    echo "You must provide a configuration file" && exit 1
fi

configuration=$1

# check if the configuration file exists

if [ ! -f ${configuration} ]
then
    echo "Cannot find the configuration file ${configuration}" && exit 1
fi

status=0

: ${DATOMIC_STORAGE:="none"}

if [ "none" != "${DATOMIC_STORAGE}" ]
then
    : ${DATOMIC_STORAGE_WAITER:="undefined"}

    if [ "undefined" != "${DATOMIC_STORAGE_WAITER}" ]
    then
        echo Executing $DATOMIC_STORAGE_WAITER
        # The program will be executed
        ${DATOMIC_STORAGE_WAITER}
        status=$?
    fi

    if [ 0 -eq $status -a "postgres" = "${DATOMIC_STORAGE}" ]
    then
        : ${POSTGRES_URL:?"POSTGRES_URL must be set"}

        ./datomic-postgres-setup.sh
    fi

    # TODO - Cassandra storage

fi


if [ 0 -eq $status ]
then
    ./bin/transactor $*
fi

