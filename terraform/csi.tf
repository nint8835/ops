resource "helm_release" "csi_nfs" {
  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"

  name      = "csi-driver-nfs"
  chart     = "csi-driver-nfs"
  version   = "v4.6.0"
  namespace = "kube-system"
}

resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = "nfs-csi"
  }

  storage_provisioner = "nfs.csi.k8s.io"

  parameters = {
    server = "192.168.1.210"
    share  = "/volume1/Kubernetes PVs"
    subDir = "$${pvc.metadata.namespace}/$${pvc.metadata.name}"
  }
}
