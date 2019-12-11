#!/bin/bash
export KUBECONFIG=./kube_config_cluster.yml
echo - Checking Cluster Health
kubectl get pods --all-namespaces

echo - Deploy Rancher
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm repo update
kubectl create namespace cattle-system

# Install cert-manager
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.9/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.9.1
# Wait for cert-manager comes up
sleep 2m

echo - Check Status of cert-manager
kubectl get pods --namespace cert-manager

# Install Rancher
helm install rancher-stable rancher-stable/rancher --namespace cattle-system --set ingress.tls.source=rancher --set hostname=rancher.dev.lhsystems.int
echo - Check Status of rancher deployment
helm list --all-namespaces

