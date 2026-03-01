# Terraform Bootstrap Plan

This document describes the target bootstrap sequence for local VM clusters and cloud clusters.

## Bootstrap Boundary

Terraform owns:
- network and security foundations where applicable
- compute/cluster foundations where applicable
- Argo CD namespace and Helm install
- Argo CD repository credentials
- bootstrap `AppProject`
- root `Application` handoff into GitOps

GitOps owns:
- Vault
- External Secrets Operator
- Traefik
- cert-manager
- MinIO
- observability
- workload applications
- runtime desired state

## Target Stack Order

1. `vpc`
2. `iam`
3. `security`
4. `compute`
5. `bootstrap`
6. `database`
7. `storage`

Local kubeconfig-based clusters can skip cloud-only stacks and start at `bootstrap`.

## Cluster Access Modes

### `auth_mode: kubeconfig`
Use for:
- local VMs
- OrbStack/K3s
- Kind
- k3d

Required values:
- `argocd_bootstrap_config.auth_mode: "kubeconfig"`
- `argocd_bootstrap_config.kubeconfig_path`
- `argocd_bootstrap_config.kubeconfig_context`

### `auth_mode: eks`
Use for:
- AWS EKS clusters

Required values:
- `argocd_bootstrap_config.auth_mode: "eks"`
- `argocd_bootstrap_config.cluster_name`

## State Backend Model

### Cloud
Use AWS S3 backend files under:
- `/Users/charlie/Desktop/_work/infra-environments/environments/staging/backend/*.hcl`

### Local
Bootstrap should start with:
- local backend, or
- `terraform init -backend=false`

Reason:
- MinIO is a GitOps-managed runtime service and does not exist before bootstrap handoff.

After MinIO is up, local state can be migrated to the S3-compatible backend example:
- `/Users/charlie/Desktop/_work/infra-environments/environments/staging/backend/bootstrap-minio.hcl.example`

## MinIO Role

MinIO is the local object store for:
- Terraform state in local environments after bootstrap
- platform backups
- application object storage where desired

MinIO does not replace AWS infrastructure resources. It replaces only S3-compatible storage use cases.

## Core Tooling Target

After a successful bootstrap handoff, these core tools should exist through GitOps:
- Argo CD
- Vault
- External Secrets Operator
- Traefik
- cert-manager
- MinIO
- Prometheus stack
- Loki

## Environment-Agnostic Module Rules

All caller stacks and modules should:
- use object-typed config blocks
- support `enabled` toggles or module gating through `modules_enabled`
- prefer outputs/remote state over duplicated tfvars
- avoid embedding secrets in repo-tracked files
- use the same module interface for local and cloud where practical

## Autodiscovery Rules

Cross-stack data should flow through:
- module outputs
- remote state
- caller-level wiring

Avoid:
- copying IDs into `.tfvars`
- duplicating subnet IDs, SG IDs, or VPC IDs across stacks

## Immediate Completion Tasks

1. finish live MinIO Vault seed and Argo reconciliation
2. verify local bootstrap on a clean kubeconfig-based cluster
3. migrate local bootstrap state to MinIO backend
4. expand `vpc`, `security`, and `compute` caller stacks to fully consume remote state outputs
5. define VM bootstrap path where user-data is either:
   - minimal and validated, or
   - replaced by post-provision configuration scripts when user-data is too brittle

## User-Data Rule

User-data should be:
- minimal
- idempotent
- log to a known file
- validated on a disposable instance before being treated as standard

Anything complex should move to a maintained bootstrap script or configuration management step.

## Troubleshooting Sequence

### Bootstrap fails before Argo is up
Check:
- cluster access mode
- kubeconfig context or EKS cluster name
- repo credentials
- Helm release status for Argo CD

### Bootstrap fails after Argo is up
Check:
- `platform-root`
- `platform-tools`
- chart repo reachability
- private repo credentials

### MinIO fails
Check:
- `vault-access` health
- `vault-platform-tools-minio` store existence
- `minio-root-credentials` `ExternalSecret`
- Vault path:
  - `kv/temitayo/staging/platform-tools/minio`

### Local backend migration fails
Check:
- MinIO endpoint reachability
- root credentials
- bucket existence
- path-style backend settings

## Success Criteria

The bootstrap layer is complete when:
- a fresh local cluster can bootstrap Argo CD through Terraform
- `platform-root` and `platform-tools` reconcile without manual fixes
- MinIO comes up under GitOps
- local Terraform state can be migrated into MinIO
- cloud environments can still use AWS S3 backends unchanged
