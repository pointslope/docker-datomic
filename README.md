# Datomic Pro Docker Template

This Dockerfile provides a template to build a Docker image for
[Datomic Pro](http://www.datomic.com/). It defines the necessary
automation steps for running Datomic, while deferring all privileged,
user-specific configuration to a derived image via **ONBUILD**
instructions.

This approach makes it trivial to customize your own Dockerfile to run
any supported Datomic configuration. To do so, you need only to follow
these steps:

1. Create a `Dockerfile` that is based **FROM** this image
2. Create a `.version` file with the Datomic Pro version that should
   be installed.
3. Create a `.credentials` file containing your http user and password
   for downloading from **my.datomic.com** in the form `user:pass`
4. Create a `config` folder where your `Dockerfile` resides and place
   your Datomic transactor.properties config file(s) within it
5. Add a **CMD** instruction in your `Dockerfile` with the relative
   path to that file e.g. **config/transactor.properties**

## Example Folder Structure

    .
    ├── .credentials
    ├── .version
    ├── Dockerfile
    └── config
        └── transactor.properties

## Example Dockerfile

    FROM simplevalue/datomic-pro-template:0.1.0
    CMD ["config/transactor.properties"]

## Miscellany

The Dockerfile **EXPOSES** port 4334. Datomic will reside in the
folder `/opt/datomic`. If you use Datomic's dev protocol and you want
to keep the data, then mount an appropriate volume into the container,
example:

    docker run -v $PWD/data:/opt/datomic/data ...

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
