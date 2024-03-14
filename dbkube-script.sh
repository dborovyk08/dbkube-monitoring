#!/bin/bash

# Define Kubernetes namespace

#Setup nginx-hello-text app
kubectl create deployment nginx-hello-text --image=nginxdemos/hello:plain-text
kubectl expose deployment nginx-hello-text --type=NodePort --port=80
kubectl scale deploy nginx-hello-text --replicas=3

# Set up Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np

# Set up Grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np

# Print summary
echo "All components deployed successfully."
