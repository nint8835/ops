resource "helm_release" "csi_nfs" {
  name      = "csi-driver-nfs"
  namespace = "kube-system"

  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
  version    = "4.12.1"
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
