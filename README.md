# terraform-kubernetes-postgres

Terraform module which deploys a postgres database on kubernetes

## Requirements

* Terraform 0.13+
* Kubernetes cluster

## Usage

Configuration

```terraform
provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "postgres" {
  source = "github.com/o0th/terraform-kubernetes-postgres"

  name      = "name"
  namespace = "namespace"

  image = "arm64v8/postgres:latest"

  database = "database"
  username = "username"
  password = "password"

  pvc = "some_pvc"
}
```

Terraform

```bash
terraform init
terraform plan
terraform apply
```


