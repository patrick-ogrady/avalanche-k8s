#!/bin/bash
prom_namespace=prometheus
ava_namespace=avalanche

# test deploy all
pushd ../
./deploy-cli.sh deploy all
if [ $? != 0 ]; then
    echo "FAIL deploy all"
    popd
    exit 1
fi

# test delete all
./deploy-cli.sh delete all
if [ $? != 0 ]; then
    echo "FAIL delete all"
    popd
    exit 1
fi

popd

ns=$(kubectl get namespaces | grep ava)
if [ "$ns" != "" ]; then
    echo "ERROR: namespace exists: $ns"
    exit 1
fi

ns=$(kubectl get pods -n "$prom_namespace" | grep prom)
if [ "$ns" != "" ]; then
    echo "ERROR: prometheus exists: $ns"
    exit 1
fi

ns=$(kubectl get pods -n "$prom_namespace" | grep grafana)
if [ "$ns" != "" ]; then
    echo "ERROR: prometheus exists: $ns"
    exit 1
fi

kubectl get namespace | grep "$ava_namespace"
if [ $? == 0 ]; then
    echo "ERROR: $ava_namespace namespace exists"
    exit 1
fi

kubectl get namespace | grep "$prom_namespace"
if [ $? == 0 ]; then
    echo "ERROR: $prom_namespace namespace exists"
    exit 1
fi

echo "SUCCESS"
exit 0

