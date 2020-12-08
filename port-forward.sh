#!/bin/bash
set -e
function usage() {
    echo -e 'Usage:'
    echo -e '\tgrafana\t- port forward for grafana'
    echo -e '\tprometheus\t- port forward for prometheus'
    echo -e '\avalanche\t- port forward for avalanche node'
}

if  [ $# == 0 ]; then
    usage
    exit 1
fi

prom_namespace=prometheus
avalanche_ns=avalanche

if [ "$1" ==  "grafana" ]; then
    echo "Connect to grafana using localhost:3000"
    kubectl port-forward -n "$prom_namespace" $(kubectl get pod -n "$prom_namespace" --selector="app.kubernetes.io/instance=prometheus-stack,app.kubernetes.io/name=grafana" --output jsonpath='{.items[0].metadata.name}') 3000:3000
elif [ "$1" ==  "prometheus" ]; then
    echo "Connect to prometheus using localhost:8090"
    kubectl port-forward -n "$prom_namespace" $(kubectl get pod -n "$prom_namespace" --selector="app=prometheus,prometheus=prometheus-stack-kube-prom-prometheus" --output jsonpath='{.items[0].metadata.name}') 8090:9090
elif [ "$1" ==  "avalanche" ]; then
    echo "Connect to avalanche using localhost:8070"
    kubectl port-forward -n "$avalanche_ns" $(kubectl get pod -n $avalanche_ns --selector="app.kubernetes.io/name=kube-avax,app.kubernetes.io/instance=ava-node" --output jsonpath='{.items[0].metadata.name}') 8090:9090
else
    echo "Invalid option. Allowed: grafana, prometheus"
    exit 1
fi
