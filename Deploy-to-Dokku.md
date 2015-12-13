# Deploy your S3Proxy to Dokku

[Dokku](http://dokku.viewdocs.io/dokku/) is a Docker powered open source Platform as a Service that runs on any hardware or cloud provider.

## Prerequisites
Setup a [Dokku](http://dokku.viewdocs.io/dokku/installation/#installing-via-other-methods) environment in your cloud provider of choice. For example, you can following this [guide](http://dokku.viewdocs.io/dokku/getting-started/install/azure/) to install a Dokku instance on Microsoft Azure.

## Update Your S3Proxy Dockerfile
Similar to running S3Proxy as a container locally, you need to update your [s3proxy.conf](s3proxy.conf) file like [s3proxydokku.conf](s3proxydokku.conf) by replacing the [[dokku public ip]] value with the new dokku instance you have previously provisioned.

## Deploy S3Proxy as a Docker App

- From your local dev machine, git clone this repo:
```
$ git clone https://github.com/ritazh/s3proxydocker.git
```
- SSH into the Dokku vm in your Dokku instance
```
$ ssh -i ~/.ssh/dokku [[dokkuAdminCreatedDuringInstallation]]@[[dnsNameForPublicIP]].[[location]].cloudapp.azure.com
```
- Create a new Dokku app:
```
$ dokku apps:create s3proxy
```

- From your local dev machine, add a Dokku remote to your local repo using the Dokku username and push the app:
```
$ ssh-add <your-dokku-deploy-private-key>
$ git remote add dokku dokku@[[DNSNAMEFORPUBLICIP]].[[LOCATION]].cloudapp.azure.com:[[app name]]
$ git push dokku master
```

- When you need to update the solution, simply follow the usual git flow to push updates to dokku:

```
$ git add
$ git commit 
$ git push dokku master
```

- Since S3Proxy treats all buckets and containers as sub-subdomains, we need to add a wildcard for our sub-subdomains to your Dokku app subdomain. You can do one of the following:

1. update your app's nginx.conf manually on the Dokku VM:

```
$ sudo vi /home/dokku/s3proxy/nginx.conf
$ sudo nginx -s reload
```

2. Update the nginx domain server name with a wildcard sub-subdomain url, use the Dokku domains plugin.

From the Dokku vm:
```
$ dokku domains:add s3proxy *.s3proxy.[[PublicIP]].xip.io
```
Sample output:

```
-----> Configuring s3proxy.[[PublicIP]].xip.io...
-----> Configuring *.s3proxy.[[PublicIP]].xip.io...
-----> Creating http nginx.conf
-----> Running nginx-pre-reload
       Reloading nginx
-----> Configuring s3proxy.[[PublicIP]].xip.io...
-----> Configuring *.s3proxy.[[PublicIP]].xip.io...
-----> Creating http nginx.conf
-----> Running nginx-pre-reload
       Reloading nginx
-----> Added *.s3proxy.[[PublicIP]].xip.io to s3proxy
```
To review the latest domains for the S3Proxy Dokku app:
```
$ dokku domains s3proxy
```
Sample output:

```
=====> s3proxy Domain Names
s3proxy.[[PublicIP]].xip.io
*.s3proxy.[[PublicIP]].xip.io
```

To review the updated nginx.conf, do the following:
```
$ sudo cat /home/dokku/s3proxy/nginx.conf 
```
Sample output:
```
server {
  listen      [::]:80;
  listen      80;
  server_name s3proxy.[[PublicIP]].xip.io *.s3proxy.[[PublicIP]].xip.io ;
  access_log  /var/log/nginx/s3proxy-access.log;
  error_log   /var/log/nginx/s3proxy-error.log;

...
```
To include other configurations of nginx, we can add new configurations files under `/home/dokku/myapp/nginx.conf.d/`. 
```
$ sudo su
mkdir /home/dokku/myapp/nginx.conf.d/
echo 'client_max_body_size 50M;' > /home/dokku/myapp/nginx.conf.d/upload.conf
chown dokku:dokku /home/dokku/myapp/nginx.conf.d/upload.conf
nginx -s reload
```
