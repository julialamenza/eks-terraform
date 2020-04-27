## EKS + Terraform

With this repository you will be able to spin up a eks and deploy a nginx manifest using terraform.
This repository have everything that you need to make your eks works, including network part.

First you should export your AWS credentials

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

clone this repository

```
git clone https://github.com/julialamenza/eks-terraform.git
```
**Terraform Commands**

```
cd eks-terraform/
```

RUN

```
terraform plan -o teste-tf
```
the "-o" will copy the output to teste-tf

After RUN

```
terraform apply -o teste-tf
```

After this you could use my eksconfig.sh to ble to config your
kubeconfig and config-map to conect your eks with your kubectl and be able to manage your  pods, nodes, etc.
<br>
And also apply directly the kb8s-manifest module

Inside the project directory run:

``` 
chmod +x ./eksconfig.sh
```
./eksconfig.sh

**or**

You can follow the commands bellow

Inside the root directory 
You should run

```
terraform init
terraform plan -o teste-tf
```
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
```

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
```

Confirm your Nodes:

```
kubectl get nodes
````
---------------------------

**After this we will receive a elbhostname if you copy this link you will be able to visualize this message:

```
WORKS!!!!!
```

Go everything works.

To destroy use ``` terraform destory ``` inside **kb8s-manifest** module and after from Project root directory and you will be able to delete all your infraestructure and deployment.


- IF you wanna you can deploy kafka cluster using the **APP2**
For this you just need the eks.
 go to **APP2** directory

 RUN:
 ````
 kubectl apply -f zookeeper.yml
 ````
Watch for all of the Pods in the StatefulSet to become Running and Ready.
```
kubectl get po -lapp=zk -w
```

You need to configure the Kafka cluster to communicate with the zookeeper ensemble you created above

```
kubectl apply -f kafka.yml
```
Wait for all of the Pods to become Running and Ready.

```
kubectl get po -lapp=kafka -w

```

**Testing the cluster ***
First you will need to create a topic. You can use kubectl run to execute the kafka-topics.sh script.

```
kubectl run -ti --image=gcr.io/google_containers/kubernetes-kafka:1.0-10.2.1 createtopic --restart=Never --rm -- kafka-topics.sh --create \
--topic test \
--zookeeper zk-cs.default.svc.cluster.local:2181 \
--partitions 1 \
--replication-factor 3
```
Now use kubectl run to execute the kafka-console-consumer.sh command and listen for messages.

```
kubectl run -ti --image=gcr.io/google_containers/kubernetes-kafka:1.0-10.2.1 consume --restart=Never --rm -- kafka-console-consumer.sh --topic test --bootstrap-server kafka-0.kafka-hs.default.svc.cluster.local:9093
```

In another terminal, run the kafka-console-producer.sh command.

```
kubectl run -ti --image=gcr.io/google_containers/kubernetes-kafka:1.0-10.2.1 produce --restart=Never --rm \
 -- kafka-console-producer.sh --topic test --broker-list kafka-0.kafka-hs.default.svc.cluster.local:9093,kafka-1.kafka-hs.default.svc.cluster.local:9093,kafka-2.kafka-hs.default.svc.cluster.local:9093 done;
 ````
When you type text into the second terminal. You will see it appear in the first.


On this kafka and zookeerper par I use the default paramaters and manifests from - https://github.com/kow3ns/kubernetes-kafka/tree/master/manifests
