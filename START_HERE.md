# START HERE

## 1. Prerequisites
- Terraform `>= 1.6.0, < 2.0.0`
- AWS credentials configured
- Existing S3 bucket (+ optional DynamoDB lock table) for remote state

## 2. Environment baseline
- Edit [environments/staging/environment.yaml](./environments/staging/environment.yaml)
- Keep secrets out of this repo (use Vault / Secrets Manager)

## 3. Deploy order
1. [environments/staging/stacks/vpc](./environments/staging/stacks/vpc)
2. [environments/staging/stacks/iam](./environments/staging/stacks/iam)
3. [environments/staging/stacks/security](./environments/staging/stacks/security)
4. [environments/staging/stacks/compute](./environments/staging/stacks/compute)
5. [environments/staging/stacks/database](./environments/staging/stacks/database)
6. [environments/staging/stacks/storage](./environments/staging/stacks/storage)

## 4. Example commands
```bash
cd environments/staging/stacks/vpc
terraform init -backend-config=../../backend/vpc.hcl
terraform plan
terraform apply
```

Repeat stack-by-stack in order.


## 8. Upgrade Module Version
1. Create or pick a new release tag in `terraform-module` (example: `v1.1.0`).
2. Update all `source = "git::...terraform-module...?...ref=vX.Y.Z"` pins in this repo.
3. Run:
```bash
./scripts/check_module_pins.sh .
terraform fmt -recursive
for d in environments/staging/stacks/*; do
  terraform -chdir="$d" init -backend=false
  terraform -chdir="$d" validate
done
```
4. Commit and merge after CI is green.
