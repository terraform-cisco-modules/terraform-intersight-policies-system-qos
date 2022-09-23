terraform {
  experiments = [module_variable_optional_attrs]
}

#____________________________________________________________
#
# System QoS Policy Variables Section.
#____________________________________________________________

variable "classes" {
  default = [
    {
      bandwidth_percent  = 50
      class              = "Best Effort"
      cos                = 0
      mtu                = 1500
      multicast_optimize = false
      packet_drop        = true
      state              = "Disabled"
      weight             = 0
    }
  ]
  description = <<-EOT
    * bandwidth_percent - Percentage of bandwidth Assigned to traffic traffic tagged with this Class.
    * class - Name of the priority class.
      1. Best Effort
      2. Bronze
      3. FC
      4. Gold
      5. Platinum
      6. Silver
    * cos - Class of service Assigned to the System QoS Class.
      1. Best Effort - By default is 255 and cannot be changed.
      2. Bronze - By default is 1.
      3. FC - By default is 3 and cannot be changed.
      4. Gold - By default is 4.
      5. Platinum - By default is 5.
      6. Silver - By default is 2.
    * mtu - Maximum transmission unit (MTU) is the largest size packet or frame,that can be sent in a packet- or frame-based network such as the Internet.  Range is 1500-9216.
      - FC is 2240 and cannot be changed
      - All other priorities have a default of 1500 but can be configured in the range of 1500 to 9216.
    * multicast_optimize - Default is false.  If enabled, this QoS class will be optimized to send multiple packets.
    * state - Administrative state for the QoS class.
      - Disabled - Admin configured Disabled State.
      - Enabled - Admin configured Enabled State.
      Note: "Best Effort" and "FC" Classes are "Enabled" and cannot be "Disabled".
    * weight - The weight of the QoS Class controls the distribution of bandwidth between QoS Classes,with the same priority after the Guarantees for the QoS Classes are reached.
      1. Best Effort - By default is 5.
      2. Bronze - By default is 7.
      3. FC - By default is 5.
      4. Gold - By default is 9.
      5. Platinum - By default is 10.
      6. Silver - By default is 8.
  EOT
  type = list(object(
    {
      bandwidth_percent  = optional(number)
      class              = string
      cos                = optional(number)
      mtu                = optional(number)
      multicast_optimize = optional(bool)
      packet_drop        = optional(bool)
      state              = optional(string)
      weight             = optional(number)
    }
  ))
}

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "name" {
  default     = "default"
  description = "Name for the Policy."
  type        = string
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "profiles" {
  default     = []
  description = "List of UCS Domain Profile Moids to Assign to the Policy."
  type        = list(string)
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}
