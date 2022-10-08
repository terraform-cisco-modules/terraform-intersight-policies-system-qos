<!-- BEGIN_TF_DOCS -->
# System QoS Policy Example

### main.tf
```hcl
module "system_qos" {
  source  = "terraform-cisco-modules/policies-system-qos/intersight"
  version = ">= 1.0.1"

  classes = [
    {
      bandwidth_percent = 20
      class             = "Platinum"
      cos               = 5
      mtu               = 9216
      packet_drop       = false
      state             = "Enabled"
      weight            = 10
    },
    {
      bandwidth_percent = 18
      class             = "Gold"
      cos               = 4
      mtu               = 9216
      packet_drop       = true
      state             = "Enabled"
      weight            = 9
    },
    {
      bandwidth_percent = 20
      class             = "FC"
      cos               = 3
      mtu               = 2240
      packet_drop       = false
      state             = "Enabled"
      weight            = 10
    },
    {
      bandwidth_percent = 18
      class             = "Silver"
      cos               = 2
      mtu               = 9216
      packet_drop       = true
      state             = "Enabled"
      weight            = 8
    },
    {
      bandwidth_percent = 14
      class             = "Bronze"
      cos               = 1
      mtu               = 9216
      packet_drop       = true
      state             = "Enabled"
      weight            = 7
    },
    {
      bandwidth_percent = 10
      class             = "Best Effort"
      cos               = 255
      mtu               = 9216
      packet_drop       = true
      state             = "Enabled"
      weight            = 5
    },
  ]
  description  = "default System QoS Policy."
  name         = "default"
  organization = "default"
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

To run this example you need to execute:

```bash
terraform init
terraform plan -out="main.plan"
terraform apply "main.plan"
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.
<!-- END_TF_DOCS -->