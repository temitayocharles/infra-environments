# Execution Backlog

This is the remaining execution backlog after the bootstrap and MinIO source work.

## 1. Live MinIO Reconciliation

Status:
- source is pushed
- Argo `Application` exists
- Vault store is valid
- Vault secret path has been seeded

Remaining verification:
1. `minio` application reports sync/health state
2. `ExternalSecret` creates `minio-root-credentials`
3. MinIO chart resources render in namespace `minio`
4. MinIO pods become healthy
5. `platform-state` and `platform-artifacts` buckets exist

## 2. Local Bootstrap Proof

Goal:
- bootstrap a fresh kubeconfig-based cluster using local state first
- confirm Argo handoff and platform tool creation

Acceptance:
- Argo CD installed
- `platform-root` reconciles
- `platform-tools` reconciles
- MinIO application is created and healthy

## 3. Local State Migration to MinIO

After MinIO is healthy:
1. create or verify the state bucket
2. use:
   - `/Users/charlie/Desktop/_work/infra-environments/environments/staging/backend/bootstrap-minio.hcl.example`
3. migrate bootstrap state from local backend into MinIO

## 4. VPC and Security Stack Completion

For cloud environments:
1. validate `vpc` caller stack
2. validate `security` caller stack
3. ensure security group modules use object-typed rule inputs
4. wire downstream stacks to outputs/remote state instead of copied IDs

## 5. Compute and VM Bootstrap

Goal:
- support a VM bootstrap path that is reliable in both cloud and local-like environments

Rules:
- keep user-data minimal
- log user-data output
- move complex setup into versioned scripts or runbooks
- verify on disposable instances

## 6. Full Platform Bootstrap Drill

On a fresh cluster:
1. Terraform bootstrap
2. Argo handoff
3. core platform tools healthy
4. local state migrated to MinIO
5. workload pause/resume model still intact

## 7. Backup and Restore Closure

MinIO should become the local storage target for:
- Terraform state
- local platform backups

Then verify:
- backup artifacts are written
- restore path is documented
- restore drill works on a fresh cluster
