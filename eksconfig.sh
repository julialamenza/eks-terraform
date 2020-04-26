#!/bin/sh
cat terraform output kubeconfig > ${HOME}/.kube/config-teste-tf
export KUBECONFIG=${HOME}/.kube/config-teste-tf:${HOME}/.kube/config
echo "export KUBECONFIG=${KUBECONFIG}" >> ${HOME}/.zshrc
cat terraform output config-map > /tmp/config-map-aws-auth.yml
kubectl apply -f /tmp/config-map-aws-auth.yml
