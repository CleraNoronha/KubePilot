#!/usr/bin/env bash
set -Eeuo pipefail

NAMESPACE="kubepilot"
DEPLOYMENT="kubepilot-health"
SERVICE="kubepilot-health"

echo "==> Checking Kubernetes connectivity..."
kubectl cluster-info >/dev/null

echo "==> Checking namespace..."
kubectl get namespace "$NAMESPACE" >/dev/null

echo "==> Checking deployment availability..."
kubectl rollout status "deployment/$DEPLOYMENT" \
  --namespace "$NAMESPACE" --timeout=60s

echo "==> Checking service..."
kubectl get service "$SERVICE" \
  --namespace "$NAMESPACE" >/dev/null

echo "==> Checking ready service endpoints..."
ENDPOINTS="$(kubectl get endpointslices \
  --namespace "$NAMESPACE" \
  --selector="kubernetes.io/service-name=$SERVICE" \
  -o jsonpath='{range .items[*].endpoints[?(@.conditions.ready==true)]}{.addresses[*]}{"\n"}{end}')"

if [[ -z "$ENDPOINTS" ]]; then
  echo "ERROR: Service has no ready endpoints."
  exit 1
fi

echo "Ready endpoint IP(s): $ENDPOINTS"
echo "SUCCESS: KubePilot platform validation passed."
