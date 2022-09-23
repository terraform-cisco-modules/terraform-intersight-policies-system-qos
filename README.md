<!-- BEGIN_TF_DOCS -->
# Terraform Intersight Policies - System QoS
Manages Intersight System QoS Policies

Location in GUI:
`Policies` » `Create Policy` » `System QoS`

## Example

### main.tf
```hcl
module "system_qos_policy" {
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
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```

### versions.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = var.secretkey
}
```

### Environment Variables

Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with value of [your-api-key]
- Add variable secretkey with value of [your-secret-file-content]

Linux
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkey=`cat <secret-key-file-location>`
```

Windows
```bash
$env:TF_VAR_apikey="<your-api-key>"
$env:TF_VAR_secretkey="<secret-key-file-location>""
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apikey"></a> [apikey](#input\_apikey) | Intersight API Key. | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Intersight URL. | `string` | `"https://intersight.com"` | no |
| <a name="input_secretkey"></a> [secretkey](#input\_secretkey) | Intersight Secret Key. | `string` | n/a | yes |
| <a name="input_classes"></a> [classes](#input\_classes) | * bandwidth\_percent - Percentage of bandwidth Assigned to traffic traffic tagged with this Class.<br>* class - Name of the priority class.<br>  1. Best Effort<br>  2. Bronze<br>  3. FC<br>  4. Gold<br>  5. Platinum<br>  6. Silver<br>* cos - Class of service Assigned to the System QoS Class.<br>  1. Best Effort - By default is 255 and cannot be changed.<br>  2. Bronze - By default is 1.<br>  3. FC - By default is 3 and cannot be changed.<br>  4. Gold - By default is 4.<br>  5. Platinum - By default is 5.<br>  6. Silver - By default is 2.<br>* mtu - Maximum transmission unit (MTU) is the largest size packet or frame,that can be sent in a packet- or frame-based network such as the Internet.  Range is 1500-9216.<br>  - FC is 2240 and cannot be changed<br>  - All other priorities have a default of 1500 but can be configured in the range of 1500 to 9216.<br>* multicast\_optimize - Default is false.  If enabled, this QoS class will be optimized to send multiple packets.<br>* state - Administrative state for the QoS class.<br>  - Disabled - Admin configured Disabled State.<br>  - Enabled - Admin configured Enabled State.<br>  Note: "Best Effort" and "FC" Classes are "Enabled" and cannot be "Disabled".<br>* weight - The weight of the QoS Class controls the distribution of bandwidth between QoS Classes,with the same priority after the Guarantees for the QoS Classes are reached.<br>  1. Best Effort - By default is 5.<br>  2. Bronze - By default is 7.<br>  3. FC - By default is 5.<br>  4. Gold - By default is 9.<br>  5. Platinum - By default is 10.<br>  6. Silver - By default is 8. | <pre>list(object(<br>    {<br>      bandwidth_percent  = optional(number)<br>      class              = string<br>      cos                = optional(number)<br>      mtu                = optional(number)<br>      multicast_optimize = optional(bool)<br>      packet_drop        = optional(bool)<br>      state              = optional(string)<br>      weight             = optional(number)<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "bandwidth_percent": 50,<br>    "class": "Best Effort",<br>    "cos": 0,<br>    "mtu": 1500,<br>    "multicast_optimize": false,<br>    "packet_drop": true,<br>    "state": "Disabled",<br>    "weight": 0<br>  }<br>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | List of UCS Domain Profile Moids to Assign to the Policy. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | System QoS Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_fabric_system_qos_policy.system_qos](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_system_qos_policy) | resource |
| [intersight_fabric_switch_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_switch_profile) | data source |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
<!-- END_TF_DOCS -->