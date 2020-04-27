#!/bin/sh
#copy and export kubeconfig
terraform output kubeconfig > ${HOME}/.kube/config-teste-tf
export KUBECONFIG=${HOME}/.kube/config-teste-tf:${HOME}/.kube/config
echo "export KUBECONFIG=${KUBECONFIG}" >> ${HOME}/.zshrc
#copy and apply config-map
terraform output config-map > /tmp/config-map-aws-auth.yml
kubectl apply -f /tmp/config-map-aws-auth.yml
# Go to kb8s manifest directory
cd modules/kb8s-manifest/
# Apply kb8s-manifest 
terraform apply 