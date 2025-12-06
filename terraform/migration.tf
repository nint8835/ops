removed {
  from = kubernetes_storage_class.nfs
  lifecycle {
    destroy = false
  }
}

import {
  to = kubernetes_storage_class_v1.nfs
  id = "nfs-csi"
}
