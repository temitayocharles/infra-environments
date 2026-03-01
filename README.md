# Infra Environments

Environment instantiation repository for real infrastructure deployments.

## Start Here
- [START_HERE.md](./START_HERE.md)
- [docs/dependency-graph.md](./docs/dependency-graph.md)

## Purpose
This repo composes reusable modules from [terraform-module](https://github.com/temitayocharles/terraform-module) into deployable environments.

## Environments
- [environments/staging](./environments/staging)

## Notes
- This repo is the environment layer (stateful, deployable).
- Reusable modules remain in `terraform-module`.
- Local clusters can use MinIO as an S3-compatible backend after the bootstrap handoff is complete.


## Module Version Pinning
- All module sources must be pinned to a release tag: `?ref=vX.Y.Z`.
- Floating refs (`main`, `master`, `HEAD`) are blocked in CI by [`scripts/check_module_pins.sh`](./scripts/check_module_pins.sh).
- Current baseline is `v1.0.0` from [`terraform-module`](https://github.com/temitayocharles/terraform-module/releases/tag/v1.0.0).


## Architecture Maps
- [DEPENDENCY_LADDER.md](./DEPENDENCY_LADDER.md)
- [ARCHITECTURE.md](./ARCHITECTURE.md)

- AWS credentials are only required when `auth_mode: eks`.

## Local MinIO Backend
- The bootstrap stack should start with local state or `terraform init -backend=false` when MinIO is not available yet.
- After Argo CD brings up MinIO, local state can be migrated to the S3-compatible backend example at:
  - `/Users/charlie/Desktop/_work/infra-environments/environments/staging/backend/bootstrap-minio.hcl.example`
- Cloud environments should continue using AWS S3 backends.
