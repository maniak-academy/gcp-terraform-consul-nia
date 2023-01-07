Steps 

1. Create a project 
2. Enable Compute Engine API
3. Enable K8s API Engine
4. apply the terraform code to build the environment
5. 
4. Log into you google cloud account with gcloud init
5. Need to install the gcloud components install gke-gcloud-auth-plugin
6. Get kubectl loging gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)


consul-k8s install -config-file=values.yaml -set global.image=hashicorp/consul:1.14.3

gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)


Retrieve the ACL bootstrap token from the respective Kubernetes secret and set it as an environment variable.

```
 export CONSUL_HTTP_TOKEN=$(kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d)
```

Set the Consul destination address.

```
export CONSUL_HTTP_ADDR=https://$(kubectl get services/consul-ui --namespace consul -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Remove SSL verification checks to simplify communication to your Consul cluster.

```
 export CONSUL_HTTP_SSL_VERIFY=false
```