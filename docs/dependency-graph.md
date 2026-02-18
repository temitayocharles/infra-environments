# Dependency Graph

```text
infra-environments
  -> terraform-module (reusable modules)
  -> vault-ops (secret policy/path governance)
  -> configurations (non-secret app config pattern)
  -> platform-gitops / helm-charts (runtime deployment layer)
```
