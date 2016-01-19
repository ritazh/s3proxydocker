# Deploy S3Proxydocker to Cloud Foundry Diego

[Cloud Foundry](https://www.cloudfoundry.org/) is an open source PaaS that enables developers to deploy and scale applications in minutes, regardless of the cloud provider. Cloud Foundry with Diego can pull the S3Proxy Docker image from a Docker Registry then run and scale it as containers.

## Prerequisites
Setup a [Cloud Foundry](https://www.cloudfoundry.org/) environment in your [cloud provider of choice](https://docs.cloudfoundry.org/deploying/index.html). For example, you can follow this [guide](https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/blob/master/docs/guidance.md) to install a Cloud Foundry cluster on Microsoft Azure. Make sure you have [installed and enabled Diego](https://github.com/cloudfoundry-incubator/diego-release#deploying-diego-to-bosh-lite) in your Cloud Foundry instance. For example, you can follow this [guide](https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release/blob/master/docs/push-your-first-net-application-to-cloud-foundry-on-azure.md#deploy-diego-on-azure) for deploying Diego on Azure.

## Update S3Proxy.conf

- From your local dev machine, git clone this repo.
- Update [s3proxy.conf](/s3proxy.conf) with your own storage provider backend. I have provided an example of s3proxy.conf for Azure storage. For more options against other storage providers, checkout [S3Proxy's wiki](https://github.com/andrewgaul/s3proxy/wiki/Provider-examples)

> Make sure you update `s3proxy.virtual-host`, with the following:

```
s3proxy.virtual-host=<CLOUDFOUNDRY-APP-NAME>.<PUBLIC-URL-OF-CLOUDFOUNDRY-APP>
```
If you using `xip.io` together with the public ip of your Cloud Foundry instance, then your value may look like the following:
`s3proxy.<PUBLIC-IP-OF-CF>.xip.io` assuming your CF App is called `s3proxy`. 

## Building and Pushing a S3Proxy Docker Image to a Docker Registry

- From your local dev machine, at the root of this project, run the following from terminal:

```
$ make build
```
- Push S3Proxy Docker image to a Docker Registry
```
$ docker push [DOCKERHUB-USERNAME]/s3proxy

# For this example, we are using Docker hub. You can also do this against any public or private Docker Registry instance. Make sure your Cloud Foundry cluster has access to push/pull images from this Docker Registry.
```
## Pushing S3Proxy as an App to Cloud Foundry
The steps below assume you have already logged into a CF instance with `cf login` and `cf target`. 

- Let's push the S3Proxy image to Cloud Foundry, but we do not want to start it yet.

```
$ cf push s3proxy -o [DOCKERHUB-USERNAME]/s3proxy --no-start

```
- Use `cf apps` to get the application URL of your app. 

```
$ cf apps

# You should see the s3proxy app in the list. Check the URL of the application.
```

- If you do not have a public wildcard domain associated with this app, use the following to enable public access of the app and to map a wildcard domain to support S3Proxy's virtual host name.

```
$ cf create-domain <CF-SPACE-NAME> <PUBLIC-IP-OF-CLOUD-FOUNDRY-INSTANCE>

# Assuming your CF app is named "s3proxy", create and map a new route with public ip of cloud foundry or a public domain you want to use for this app.
$ cf map-route s3proxy <PUBLIC-IP-OF-CLOUD-FOUNDRY-INSTANCE> -n '*'

```
- Once you have a public wildcard URL associated with the s3proxy app, you can start the app:

```
$ cf start s3proxy

```
Once the app is started, you can navigate to the public URL of the app, you should see a list of containers in your storage account.










