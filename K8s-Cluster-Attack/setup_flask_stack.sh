#!/usr/bin/env bash
echo "Deploying Vul Flask Redis database"
kubectl apply  -f app-loadbalancer.yaml
kubectl apply -f app-configmap.yaml
kubectl apply -f redis-dep.yaml
kubectl apply -f redis-svc.yaml
echo "Deployment of Vul Flask Redis datase successfully completed"
echo "Deploying Vul Flask Application"
kubectl apply -f flask-dep.yaml
kubectl apply -f flask-svc.yaml
echo "Vulnerable Flask application deployed successfully"
