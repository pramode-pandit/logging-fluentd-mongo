### Overview
**Kubernetes Logging with Fluentd and Mongo**

Demo to collect the container logs with fluentd and shiping them to mongo DB for visualization and analysis.
Scope of this demo includes
- Building fluentd docker image to support output to Mongo DB 
- Creating Fluentd conf to source, filter and match the output to Mongo
- Creating fluent demonset
- Deploying Mongo DB to store the logs
- Deploying Mongo Client to Query data


##### Build fluentd-mongo image 

Gathering logs from kubernetes platform would require fluent kubernetes daemonset image which has preinstalled kubernetes filter and metadata parser
plugins that fetches information like podID, namespace, nodeName etc.
Unfortunately, fluentd-kubernetes-daemonset doesn't have any tags available for mongo. So we are going to create one for our own.

The image already present on my docker repo `openkubeio/fluend-kubernetes:v1.9-debian-mongo`

```
docker build . -t fluend-kubernetes:v1.9-debian-mongo
```

##### Deploy Mongo DB to store logs

```
kubectl apply -f mongo.stateful.standalone.yaml
```

##### Deploy Mongo Client

Run the `certs.sh` to generate certificates and secret to be consumed by ingress tls

```
sh certs.sh

kubectl apply -f mongo.client.yaml
```

##### Deploy fluentd daemonset and fluent config map
```
kubectl apply -f fluent-cm.yaml
kubectl apply -f fluent-ds.yaml
kubectl get pods -A  -l k8s-app=fluentd-logging -o wide 
```

##### View Logs

Open the mongo ui either thru the configured ingress url or via kubectl port-forward to mongo-client pod

View the `mongo.client.yaml` comment to get info on default user password and setting up the authentication 

Navigate to Tools > Shell in gui to run the  mongo commands to play around with the data

##### Reference
Below are the link to the official fluentd-kubernetes-daemonset yamls and docker repository for more insight

> https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v1.9/debian-forward
> https://github.com/fluent/fluent-plugin-mongo
> https://docs.fluentd.org/output/mongo#tag_mapped
> https://docs.fluentd.org/output/rewrite_tag_filter






