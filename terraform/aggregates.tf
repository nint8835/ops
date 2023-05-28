resource "netbox_aggregate" "ten_dot" {
  prefix = "10.0.0.0/8"
  rir_id = netbox_rir.rfc_1918.id
}

resource "netbox_aggregate" "one_seven_two" {
  prefix = "172.16.0.0/12"
  rir_id = netbox_rir.rfc_1918.id
}

resource "netbox_aggregate" "one_nine_two" {
  prefix = "192.168.0.0/16"
  rir_id = netbox_rir.rfc_1918.id
}
