# Dockerize your S3Proxy instance, make it run anywhere!

## Container Environment:
* Apache Maven 3.3.9
* Maven home: /usr/share/maven
* Java version: 1.8.0_66-internal, vendor: Oracle Corporation
* Java home: /usr/lib/jvm/java-8-openjdk-amd64/jre
* Default locale: en, platform encoding: UTF-8
* jetty-9.2.z-SNAPSHOT

## Prerequisites
- [docker][]
- Understand fundamentals of S3Proxy: configuration and setup - [S3Proxy](https://github.com/andrewgaul/s3proxy)

## Getting Started
- Update [s3proxy.conf](/s3proxy.conf) with your own storage provider backend. I have provided an example of s3proxy.conf for Azure storage. For more options against other storage providers, checkout [S3Proxy's wiki](https://github.com/andrewgaul/s3proxy/wiki/Provider-examples)
- If you have a need for `s3proxy.virtual-host`, update [s3proxy.conf](/s3proxy.conf) with your own docker ip. 

To find the docker ip:
```
$ docker-machine ip [docker machine name]

Sample output:
192.168.99.100

```
- Build docker image:

`$ make build`

- Run S3Proxy container:

`$ docker run -t -i -p 8080:8080 s3proxy`

If you cannot get to the internet from the container, use the following:
`docker run --dns 8.8.8.8 -t -i -p 8080:8080 s3proxy`



