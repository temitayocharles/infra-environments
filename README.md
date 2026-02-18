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


## Module Version Pinning
- All module sources must be pinned to a release tag: `?ref=vX.Y.Z`.
- Floating refs (`main`, `master`, `HEAD`) are blocked in CI by [`scripts/check_module_pins.sh`](./scripts/check_module_pins.sh).
- Current baseline is `v1.0.0` from [`terraform-module`](https://github.com/temitayocharles/terraform-module/releases/tag/v1.0.0).


## Architecture Maps
- [DEPENDENCY_LADDER.md](./DEPENDENCY_LADDER.md)
- [ARCHITECTURE.md](./ARCHITECTURE.md)
