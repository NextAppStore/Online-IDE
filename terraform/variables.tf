########################################
# CUSTOM variables (optional)
# Set by the user
########################################

variable "users" {
  description = "Per-team roster — vom Worker injiziert. @platform:internal"
  type = map(list(object({
    email = string
  })))
  default = {}
}

# Per-team example: each study group (team) is assigned its own
# flavor size in the wizard. The wizard renders one picker per
# team name; Terraform sees a ``map(string)`` with
# ``team_name → flavor_id`` entries. Example for the new
# ``var_scope`` marker extension — proves that not only
# file variables can be scoped.
variable "team_flavor_ids" {
  description = "[CONTRACT] Flavor-ID pro Team — Picker-Auswahl @openstack:flavor:id:single:team"
  type        = map(string)
  default     = {}
}

variable "assignment_files" {
  description = "Vom Dozenten hochgeladene Aufgaben als ZIP pro Team @openstack:file:team:zip"
  type = map(map(object({
    name         = string
    content_b64  = string
    content_type = string
    size         = number
  })))
  default = {}
}

########################################
# CONTRACT variables (REQUIRED)
# Set by the worker/platform
########################################

variable "image_name" {
  description = "Glance-Image-Name — vom Worker zur Apply-Zeit gesetzt. @platform:internal"
  type        = string
  default     = "online-ide-vX"
}

variable "network_uuid" {
  description = "UUID des internen Netzwerks @openstack:network:id"
  type        = string
  # DHBWV6: dual-stack (v4+v6 on the same subnet pair) — every VM
  # automatically gets both fixed IPs from Neutron.
  default = "9b579624-d844-4df3-b38d-89978b31d37d"
}

variable "floating_ip_pool" {
  description = "Name des External Networks für Floating IPs @openstack:floating_ip_pool:name"
  type        = string
  default     = "DHBWV6"
}

variable "shared_secgroup_id" {
  description = "ID der gemeinsamen Security Group @openstack:security_group:id"
  type        = string
  default     = "934851d7-90a2-42ab-927c-fae610697fc7"
}