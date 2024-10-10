#/bin/bash

# This was adapted from the original script in the SPIRE repository
# https://github.com/spiffe/spire-tutorials/blob/d27c579eb4f4e26f36f60373446c42c4ebd1e3da/k8s/envoy-x509/scripts/pre-set-env.sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PREREQS_DIR="$DIR/prereqs"
OPA_DIR="$DIR/envoy-opa"

bb=$(tput bold) || true
nn=$(tput sgr0) || true
red=$(tput setaf 1) || true
green=$(tput setaf 2) || true

register() {
    kubectl exec -n spire spire-server-0 -c spire-server -- /opt/spire/bin/spire-server entry create $@
}

wait_for_agent() {
    for ((i=0;i<120;i++)); do
        if ! kubectl -nspire rollout status statefulset/spire-server; then
            sleep 1
            continue
        fi
        if ! kubectl -nspire rollout status daemonset/spire-agent; then
            sleep 1
            continue
        fi
        if ! kubectl -nspire logs statefulset/spire-server -c spire-server | grep -e "$LOGLINE" ; then
            sleep 1
            continue
        fi
        echo "${bold}SPIRE Agent ready.${nn}"
        RUNNING=1
        break
    done
    if [ ! -n "${RUNNING}" ]; then
        echo "${red}Timed out waiting for SPIRE Agent to be running.${nn}"
        exit 1
    fi
}

restart_deployments() {
    kubectl scale deployment backend --replicas=0
    kubectl scale deployment backend --replicas=1

    kubectl scale deployment frontend --replicas=0
    kubectl scale deployment frontend --replicas=1

    kubectl scale deployment frontend-2 --replicas=0
    kubectl scale deployment frontend-2 --replicas=1
}

wait_for_envoy() {
    # wait until deployments are completed and Envoy is ready
    LOGLINE="DNS hosts have changed for backend-envoy"

    for ((i=0;i<30;i++)); do
        if ! kubectl rollout status deployment/backend; then
            sleep 1
            continue
        fi
        if ! kubectl rollout status deployment/frontend; then
            sleep 1
            continue
        fi
        if ! kubectl rollout status deployment/frontend-2; then
            sleep 1
            continue
        fi
        if ! kubectl logs --tail=300 --selector=app=frontend -c envoy | grep -qe "${LOGLINE}" ; then
            sleep 5
            echo "Waiting until Envoy is ready..."
            continue
        fi
        echo "Workloads ready."
        WK_READY=1
        break
    done
    if [ -z "${WK_READY}" ]; then
        echo "${red}Timed out waiting for workloads to be ready.${nn}"
        exit 1
    fi
}

echo "${bb}Creates all the resources needed to the SPIRE Server and SPIRE Agent to be available in the cluster.${nn}"
kubectl apply -k ${PREREQS_DIR} > /dev/null

echo "${bb}Waiting until SPIRE Agent is running${nn}"
wait_for_agent

echo "${bb}Creates spire agent registration entries.${nn}"
kubectl exec -n spire spire-server-0 -- \
    /opt/spire/bin/spire-server entry create \
    -node  \
    -spiffeID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s_sat:cluster:demo-cluster \
    -selector k8s_sat:agent_ns:spire \
    -selector k8s_sat:agent_sa:spire-agent


echo "${green}SPIRE agent resources creation completed.${nn}"

echo "${bb}Creating registration entry for the backend - envoy...${nn}"
register \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/ns/default/sa/default/backend \
    -selector k8s:ns:default \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:backend \
    -selector k8s:container-name:envoy

echo "${bb}Creating registration entry for the frontend - envoy...${nn}"
register \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/ns/default/sa/default/frontend \
    -selector k8s:ns:default \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:frontend \
    -selector k8s:container-name:envoy

echo "${bb}Creating registration entry for the frontend - envoy...${nn}"
register \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/ns/default/sa/default/frontend-2 \
    -selector k8s:ns:default \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:frontend-2 \
    -selector k8s:container-name:envoy

echo "${bb}Listing created registration entries...${nn}"
kubectl exec -n spire spire-server-0 -- /opt/spire/bin/spire-server entry show

echo "${bb}Applying SPIRE Envoy with OPA configuration...${nn}"
kubectl apply -k $OPA_DIR/ > /dev/null

# Restarts all deployments to pickup the new configurations
restart_deployments > /dev/null

echo "${bb}Waiting until deployments and Envoy are ready...${nn}"
wait_for_envoy > /dev/null

echo "${bb}X.509 Environment creation completed.${nn}"
