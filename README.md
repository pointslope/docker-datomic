# Datomic Pro Starter

This Dockerfile defines a base image for [Datomic Pro Starter Edition](http://www.datomic.com/). 
It defines the necessary automation steps for running Datomic, while deferring
all privileged, user-specific configuration to a derived image.

# How to download the Datomic install using *my* credentials?

Create a `.credentials` file containing your http user and password for downloading from **my.datomic.com** in the form `user:pass`

# How to provide the Transactor configuration data to start Datomic?

There are two problems:
- the configuration contains your license key which should remain confidential
- the configuration is per storage service so should be a variable per env

1. Create a `Docker volume` and add the configuration file(s) that you have tweaked to that volume

```shell
$ docker volume create datomic-config
datomic-config
$ docker volume inspect datomic-config # Sample output from MacOS...
[
    {
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/datomic-config/_data",
        "Name": "datomic-config",
        "Options": {},
        "Scope": "local"
    }
]
```

The volume `Mountpoint` is where you should place your config file

```shell
$ sudo mkdir -p /var/lib/docker/volumes/datomic-config/_data   # ensure the directory actually exists
$ sudo cp config/dev-transactor.properties /var/lib/docker/volumes/datomic-config/_data/tx.config
```

2. Add the volume when starting this image with these flags to the docker run command:

```shell
$ docker run --mount source=datomic-config-vol,destination=/opt/datomic-pro/config ...
```

3. Add the location of the configuration file in the CMD entry of your Dockerfile

```dockerfile
CMD ["/opt/datomic-pro/config/tx.config"]
```

**NB You can call your mount points, folders, configuration file anything you please, this is just a serving suggestion**

## Example Folder Contents

    .
    ├── .credentials
    ├── Dockerfile

## Example Dockerfile

```dockerfile
FROM vdart/vdart-datomic-pro-starter
MAINTAINER John Doe "jdoe@example.org"
CMD ["/opt/datomic-pro/config/tx.config"]
```

## Storage services

### Postgres

If you use the Postgres DB storage service, Datomic needs some configuration.

This image has some code to automate those steps.

Signal your use of Postgres DB by setting this environment variable in your Dockerfile

```dockerfile
ENV DATOMIC_STORAGE "postgres"
```

A script will run to ensure that a Postgres DB for Datomic has been created and properly set up.

The DB has a fixed name, called `datomic`

## Miscellany

The Dockerfile **EXPOSES** ports 4334-6

It establishes a **VOLUME** at `/opt/datomic-pro-$DATOMIC_VERSION/data`.

*This volume is useful for persisting data across runs when using the `dev` transactor storage service.*

## License

The MIT License (MIT)

Copyright (c) 2014-2017 Point Slope, LLC.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
