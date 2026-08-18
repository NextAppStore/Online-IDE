# Security group for the code-server ports.
#
# WHY THIS EXISTS AT ALL
# Every App receives ``shared_secgroup_id`` from the platform and the default
# points at ``staging-dhbw-appstore-sg`` - the security group of the App Store
# host itself, which opens 22, 80 and 443. That is the right set for a service
# behind Caddy, and the wrong one for this App: user-data starts one code-server
# per team member on 8080, 8081, 8082 … (see ``user_ports`` in main.tf).
#
# Without the group below the deployment succeeds in every visible way - the
# instance boots, Terraform reports five resources, the outputs hand out URLs -
# and every one of those URLs times out, because the packets are dropped before
# they reach the VM. Nothing in the logs says so.
#
# An App is a deployment blueprint, so the ports it needs belong to the App,
# not to the platform's group. Adding them there instead would open 8080-8099
# on the App Store host as well.

resource "random_id" "secgroup" {
  byte_length = 4
}

resource "openstack_networking_secgroup_v2" "code_server" {
  # Neutron does not require unique group names, which is precisely why the
  # suffix is here: several deployments of this App can be live at once, and
  # three groups called "online-ide-sg" are indistinguishable in the dashboard
  # at the moment someone needs to delete the right one.
  name        = "${local.app_name}-${random_id.secgroup.hex}"
  description = "code-server web UI, one port per team member"
}

# One rule for the whole block rather than one per user. The alternative -
# for_each over the users - would recreate rules whenever a team's membership
# changes, and OpenStack counts rules against a per-project quota.
#
# The upper bound is what caps team size: user-data assigns 8080 + index, so
# this admits twenty members per team. Raise it here if a team ever needs more,
# otherwise the twenty-first member gets an instance that is running and
# unreachable.
resource "openstack_networking_secgroup_rule_v2" "code_server" {
  security_group_id = openstack_networking_secgroup_v2.code_server.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8099
  remote_ip_prefix  = local.web_source_cidr
  description       = "code-server web UI (campus/VPN only)"
}

# No IPv6 counterpart: the App is deployed onto DHBWv4 (``network_uuid``), so
# the instances have no IPv6 address to reach. Should the platform ever hand
# out a dual-stack network, this file needs a second rule - OpenStack
# security-group rules are per-ethertype and the IPv4 rule above would not
# filter, or admit, a single IPv6 packet.
