#!/bin/bash

function usage() {
    echo "Usage: scale-argocd.sh [up/down/status]"
}

function get_status() {
    echo "ArgoCD Status:"
    echo "sts/argocd-application-controller: $(kubectl -n argocd get sts argocd-application-controller -o jsonpath='{.spec.replicas}')"
    echo "deploy/argocd-redis: $(kubectl -n argocd get deploy argocd-redis -o jsonpath='{.spec.replicas}')"
    echo "deploy/argocd-repo-server: $(kubectl -n argocd get deploy argocd-repo-server -o jsonpath='{.spec.replicas}')"
    echo "deploy/argocd-applicationset-controller: $(kubectl -n argocd get deploy argocd-applicationset-controller -o jsonpath='{.spec.replicas}')"
    echo "deploy/argocd-server: $(kubectl -n argocd get deploy argocd-server -o jsonpath='{.spec.replicas}')"
    echo "deploy/argocd-dex-server: $(kubectl -n argocd get deploy argocd-dex-server -o jsonpath='{.spec.replicas}')"
    echo "deploy/argocd-notifications-controller: $(kubectl -n argocd get deploy argocd-notifications-controller -o jsonpath='{.spec.replicas}')"
}

function scale() {
    local scaleUpDown=$1
    if [ -z $scaleUpDown ]; then
        echo "Must pass 'up', 'down' or 'status'"
        usage
        exit 1
    fi
    if [[ "$scaleUpDown" =~ "status" ]]; then
        get_status
        exit 0
    fi
    replicas=0
    if [[ "$scaleUpDown" =~ "up" ]]; then
        replicas=1
    fi

    kubectl -n argocd patch sts argocd-application-controller --patch '{"spec": {"replicas": '$replicas' }}'
    kubectl -n argocd patch deploy argocd-redis --patch '{"spec": {"replicas": '$replicas' }}'
    kubectl -n argocd patch deploy argocd-repo-server --patch '{"spec": {"replicas": '$replicas' }}'
    kubectl -n argocd patch deploy argocd-applicationset-controller --patch '{"spec": {"replicas": '$replicas' }}'
    kubectl -n argocd patch deploy argocd-server --patch '{"spec": {"replicas": '$replicas' }}'
    kubectl -n argocd patch deploy argocd-dex-server  --patch '{"spec": {"replicas": '$replicas' }}'
    kubectl -n argocd patch deploy argocd-notifications-controller --patch '{"spec": {"replicas": '$replicas' }}'

    get_status
}

scale $1