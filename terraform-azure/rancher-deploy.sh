#!/bin/bash
export KUBECONFIG=./kube_config_cluster.yml
echo - Checking Cluster Health
kubectl get pods --all-namespaces

echo - Deploy Rancher
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm repo update
kubectl create namespace cattle-system

helm install rancher-stable rancher-stable/rancher --namespace cattle-system --set tls=external --set hostname=rancher.jjclouds.net
echo - Check Status of rancher deployment
helm list --all-namespaces

