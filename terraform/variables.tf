########################################
# CUSTOM-Variablen (Optional)
# Werden vom User gesetzt
########################################

variable "users" {
  description = "Per-team roster — vom Worker injiziert. @platform:internal"
  type = map(list(object({
    email = string
  })))
  default = {}
}

# Per-Team-Beispiel: jeder Lehrgruppe (Team) wird im Wizard eine
# eigene Flavor-Größe zugewiesen. Der Wizard rendert einen Picker
# pro Team-Name; Terraform sieht eine ``map(string)`` mit
# ``team_name → flavor_id``-Einträgen. Beispiel für die neue
# ``var_scope``-Marker-Erweiterung — beweist, dass nicht nur
# File-Variablen scoped sein können.
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
# CONTRACT-Variablen (PFLICHT)
# Werden vom Worker/Platform gesetzt
########################################

variable "image_name" {
  description = "Glance-Image-Name — vom Worker zur Apply-Zeit gesetzt. @platform:internal"
  type        = string
  default     = "online-ide-vX"
}

variable "network_uuid" {
  description = "UUID des internen Netzwerks @openstack:network:id"
  type        = string
  # DHBWV6: dual-stack (v4+v6 auf demselben Subnetz-Paar) — jede VM
  # bekommt automatisch beide Fixed-IPs von Neutron.
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