#!/bin/sh
terraform output kubeconfig > ${HOME}/.kube/config-teste-tf
export KUBECONFIG=${HOME}/.kube/config-teste-tf:${HOME}/.kube/config
echo "export KUBECONFIG=${KUBECONFIG}" >> ${HOME}/.zshrc
kubectl apply -f /tmp/config-map-aws-auth.yml
