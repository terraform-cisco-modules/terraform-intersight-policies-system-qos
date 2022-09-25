#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
      regexall("[[:xdigit:]]{24}", var.organization)
    ) == 0
  }
  name = each.value
}

#____________________________________________________________
#
# Intersight UCS Domain Profile(s) Data Source
# GUI Location: Profiles > UCS Domain Profiles > {Name}
#____________________________________________________________

data "intersight_fabric_switch_profile" "profiles" {
  for_each = { for v in var.profiles : v => v if length(var.profiles) > 0 }
  name     = each.value
}


#__________________________________________________________________
#
# Intersight System QoS Policy
# GUI Location: Policies > Create Policy > System QoS
#__________________________________________________________________

resource "intersight_fabric_system_qos_policy" "system_qos" {
  depends_on = [
    data.intersight_fabric_switch_profile.profiles,
    data.intersight_organization_organization.org_moid
  ]
  description = var.description != "" ? var.description : "${var.name} System QoS Policy."
  name        = var.name
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  dynamic "classes" {
    for_each = { for v in var.classes : v.class => v }
    content {
      additional_properties = ""
      admin_state = length(
        regexall("(Best Effort|FC)", classes.key)
      ) > 0 ? "Enabled" : classes.value.state
      bandwidth_percent = classes.value.bandwidth_percent
      cos = classes.key == "Best Effort" ? 255 : classes.key == "FC" ? 3 : length(
        regexall("Bronze", classes.key)) > 0 && classes.value.cos != null ? 1 : length(
        regexall("Gold", classes.key)) > 0 && classes.value.cos != null ? 4 : length(
        regexall("Platinum", classes.key)) > 0 && classes.value.cos != null ? 5 : length(
      regexall("Silver", classes.key)) > 0 && classes.value.cos != null ? 2 : classes.value.cos
      mtu                = classes.key == "FC" ? 2240 : classes.value.mtu
      multicast_optimize = classes.key == "Silver" ? true : false
      name               = classes.key
      object_type        = "fabric.QosClass"
      packet_drop = length(
        regexall("(Best Effort)", classes.key)) > 0 ? true : length(
        regexall("(FC)", classes.key)
      ) > 0 ? false : classes.value.packet_drop
      weight = classes.value.weight
    }
  }
  dynamic "profiles" {
    for_each = { for v in var.profiles : v => v }
    content {
      moid        = data.intersight_fabric_switch_profile.profiles[profiles.value].results[0].moid
      object_type = "fabric.SwitchProfile"
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
