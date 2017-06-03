# Dockerize your S3Proxy Instance - Make it Run Anywhere!

[S3Proxy](https://github.com/andrewgaul/s3proxy) allows applications using the S3 API to access other storage backends, e.g., local file system, Google Cloud Storage, Microsoft Azure, OpenStack Swift. Users can use this solution to test, deploy, and run S3Proxy instance in a docker container.

## Container Environment:
* Apache Maven 3.3.9
* Maven home: /usr/share/maven
* Java version: 1.8.0_66-internal, vendor: Oracle Corporation
* Java home: /usr/lib/jvm/java-8-openjdk-amd64/jre
* Default locale: en, platform encoding: UTF-8
* jetty-9.2.z-SNAPSHOT

## Prerequisites
- Setup [docker](https://www.docker.com/)
- Understand fundamentals of S3Proxy: configuration and setup - [S3Proxy](https://github.com/andrewgaul/s3proxy)

## Getting Started
- Update [s3proxy.conf](/s3proxy.conf) with your own storage provider backend. I have provided an example of s3proxy.conf for Azure storage. For more options against other storage providers, checkout [S3Proxy's wiki](https://github.com/andrewgaul/s3proxy/wiki/Storage-backend-examples)
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

`$ docker run --dns 8.8.8.8 -t -i -p 8080:8080 s3proxy`

## Verifying Output
Sample output should be something like this:

```
I 12-08 01:35:30.616 main org.eclipse.jetty.util.log:186 |::] Logging initialized @1046ms
I 12-08 01:35:30.642 main o.eclipse.jetty.server.Server:327 |::] jetty-9.2.z-SNAPSHOT
I 12-08 01:35:30.665 main o.e.j.server.ServerConnector:266 |::] Started ServerConnector@7331196b{HTTP/1.1}{0.0.0.0:8080}
I 12-08 01:35:30.666 main o.eclipse.jetty.server.Server:379 |::] Started @1097ms
```

`docker ps` output should be similar to this:
```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS                     NAMES
789186d1debf        s3proxy                  "/bin/sh -c './target"   5 seconds ago       Up 4 seconds        0.0.0.0:8080->8080/tcp    tender_feynman
```
Since we mapped port 8080 to 8080, you can navigate to [docker ip]:8080. For example: http://192.168.99.100:8080/

## Updating Hosts File
If you are running this locally using a local ip, you will need to update your `/etc/hosts` file to add entries for the subdomains.
For example, if the root of the site is running at `http://192.168.99.100:8080/`, then make sure you add an entry in the `/etc/hosts` file for each subdomain.
If the container name is `democontainer`, then add a subdomain as follows in the hosts file.

```
192.168.99.100  democontainer.192.168.99.100
```
To verify, navigate to [CONTAINER NAME].[DOCKER MACHINE IP]:8080. For example: http://democontainer.192.168.99.100:8080/

## Testing with a Sample App
Refer to [the AWS Java sample app](https://github.com/ritazh/aws-java-sample) repo to test your S3Proxy deployment. It is a simple Java application illustrating usage of the AWS S3 SDK for Java.


## Other Deployment Options
You can push S3Proxy as a docker app to various platforms.

### Deploying to Platforms like Dokku
 [Dokku](http://dokku.viewdocs.io/dokku/) is a Docker powered open source Platform as a Service that runs on any hardware or cloud provider. Dokku can use the S3Proxy [Dockerfile](Dockerfile) to instantiate containers to deploy and scale S3Proxy with few easy commands. Follow the [Depoy-to-Dokku](Deploy-to-Dokku.md) guide to host your own S3Proxy in Dokku.

### Deploying to Platforms like Cloud Foundry
 [Cloud Foundry](https://www.cloudfoundry.org/) is an open source PaaS that enables developers to deploy and scale applications in minutes, regardless of the cloud provider. Cloud Foundry with Diego can pull the S3Proxy Docker image from a Docker Registry then run and scale it as containers. Follow the [Depoy-to-Cloud-Foundry](Depoy-to-Cloud-Foundry.md) guide to host your own S3Proxy in Cloud Foundry.

## Acknowledgements

Many thanks to @andrewgaul and @kahing for developing and maintaining S3Proxy.

