#!/bin/bash
prom_namespace=prometheus
ava_namespace=avalanche

# test deploy 
pushd ../
./deploy-cli.sh deploy prometheus
if [ $? != 0 ]; then
    echo "FAIL deploy prometheus"
    popd
    exit 1
fi

./deploy-cli.sh deploy staking tests/staking
if [ $? != 0 ]; then
    echo "FAIL deploy staking"
    popd
    exit 1
fi

./deploy-cli.sh deploy avalanche
if [ $? != 0 ]; then
    echo "FAIL deploy avalanche"
    popd
    exit 1
fi

./deploy-cli.sh deploy dashboards node-monitoring/dashboards
if [ $? != 0 ]; then
    echo "FAIL deploy dashboards"
    popd
    exit 1
fi

# test update dashboards
./deploy-cli.sh deploy dashboards node-monitoring/dashboards
if [ $? != 0 ]; then
    echo "FAIL update dashboards"
    popd
    exit 1
fi

# test avax-cli.sh
./avax-cli.sh info node
if [ $? != 0 ]; then
    echo "FAIL info node"
    popd
    exit 1
fi

./avax-cli.sh info boot
if [ $? != 0 ]; then
    echo "FAIL info boot"
    popd
    exit 1
fi

./avax-cli.sh staking get /tmp/staking_1.tgz
if [ $? != 0 ]; then
    echo "FAIL staking get"
    popd
    exit 1
fi

# delete
./deploy-cli.sh delete prometheus
if [ $? != 0 ]; then
    echo "FAIL delete prometheus"
    popd
    exit 1
fi

./deploy-cli.sh delete staking 
if [ $? != 0 ]; then
    echo "FAIL delete staking"
    popd
    exit 1
fi

./deploy-cli.sh delete avalanche
if [ $? != 0 ]; then
    echo "FAIL delete avalanche"
    popd
    exit 1
fi

popd

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

