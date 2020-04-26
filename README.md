## EKS 




**Terraform Commands**

Inside the roo directory 
You should run
````
terraform init
terraform plan -o teste-tf
````
RUN

```
terraform apply -o teste-tf
```

The terraform module stores the kubeconfig information in it’s state store. We can view it with this command:

```
terraform output kubeconfig
```
And we can save it for use with this command:
```
terraform output kubeconfig > ${HOME}/.kube/config-teste-tf
```
We now need to add this new config to the KubeCtl Config list:
```
export KUBECONFIG=${HOME}/.kube/config-teste-tf:${HOME}/.kube/config
echo "export KUBECONFIG=${KUBECONFIG}" >> ${HOME}/.zshrc
````

The terraform state also contains a config-map we can use for our EKS workers.

View the configmap:
```
terraform output config-map
```
Save the config-map:
```
terraform output config-map > /tmp/config-map-aws-auth.yml
```
Apply the config-map:

```
kubectl apply -f /tmp/config-map-aws-auth.yml
````

Confirm your Nodes:

```
kubectl get nodes
````
