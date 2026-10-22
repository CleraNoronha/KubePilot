# KubePilot — Kubernetes Platform Automation & Reliability

KubePilot is a Kubernetes platform engineering project focused on repeatable
deployments, configuration automation, workload health, observability, and
operational reliability.

## Project Goals

- Manage Kubernetes resources using reusable Kustomize configurations.
- Define workload resource requests, limits, and health probes.
- Automate validation and deployment workflows with CI/CD.
- Provision and configure infrastructure using Terraform and Ansible.
- Add monitoring and reliability checks.
- Document deployment, troubleshooting, and rollback procedures.

## Technology Stack

- Kubernetes
- Docker
- kubectl and Kustomize
- Git and GitHub Actions
- Terraform
- Ansible
- Prometheus and Grafana

## Repository Structure

- `k8s/` — Kubernetes manifests and environment overlays
- `terraform/` — Infrastructure-as-code configurations
- `ansible/` — Configuration automation
- `monitoring/` — Monitoring configuration
- `scripts/` — Validation and operational scripts
- `docs/` — Architecture and runbooks
- `.github/workflows/` — CI/CD workflows

## Project Status

Initial repository and Kubernetes base configuration created.
Implementation and validation of the platform components are in progress.

## Safety

KubePilot uses its own Kubernetes namespace. Existing applications should not
be modified as part of KubePilot development.

## Deployment Rollback and Recovery

KubePilot supports Kubernetes rolling updates and deployment rollback using native Deployment revision history.

### Recovery Test Procedure

1. Check Deployment health:
   ```bash
   kubectl get deployment kubepilot-health -n kubepilot
   ```
2. Inspect rollout history:
   ```bash
   kubectl rollout history deployment/kubepilot-health -n kubepilot
   ```
3. Apply a controlled test image update:
   ```bash
   kubectl set image deployment/kubepilot-health nginx=nginx:1.29 -n kubepilot
   ```
4. Monitor rollout completion:
   ```bash
   kubectl rollout status deployment/kubepilot-health -n kubepilot --timeout=90s
   ```
5. Roll back to the previous revision:
   ```bash
   kubectl rollout undo deployment/kubepilot-health -n kubepilot
   ```
6. Verify recovery:
   ```bash
   kubectl rollout status deployment/kubepilot-health -n kubepilot --timeout=90s
   kubectl get deployment kubepilot-health -n kubepilot -o wide
   ```
7. Restore the repository-managed development configuration:
   ```bash
   kubectl apply -k k8s/overlays/dev
   ```
8. Run platform validation:
   ```bash
   ./scripts/validate-platform.sh
   ```

### Verified Results

- Rolling update to `nginx:1.29` completed successfully.
- Rollback restored `nginx:1.28`.
- Both Deployment replicas returned to a healthy state.
- The Service had two ready endpoints.
- The platform validation script passed after recovery.

**Note:** Run these commands only in the `kubepilot` namespace. The test image must be compatible with the Deployment, and the image change is temporary; the Kustomize overlay remains the source of truth.
