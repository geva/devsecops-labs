#!/usr/bin/env bash
echo "Deleting Vul Flask Redis database"
#kubectl delete -f app-configmap.yaml
#kubectl delete -f app-loadbalancer.yaml
kubectl delete -f redis-dep.yaml
kubectl delete -f redis-svc.yaml
echo "Deleted of Vul Flask Redis datase successfully completed"
echo "Deleting Vul Flask Application"
kubectl delete -f flask-dep.yaml
kubectl delete -f flask-svc.yaml
kubectl delete pods --all
kubectl delete clusterrolebinding badboy
echo "Deleted Flask application successfully"
