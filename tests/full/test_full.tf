module "main" {
  source = "../.."
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
  description  = "${var.name} System QoS Policy."
  name         = var.name
  organization = "terratest"
}
