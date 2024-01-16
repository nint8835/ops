resource "helm_release" "nfs_subdir_external_provisioner" {
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"

  name      = "nfs-subdir-external-provisioner"
  chart     = "nfs-subdir-external-provisioner"
  namespace = "kube-system"

  set {
    name  = "nfs.server"
    value = "192.168.1.210"
  }

  set {
    name  = "nfs.path"
    value = "/volume1/Kubernetes PVs"
  }
}

resource "helm_release" "csi_nfs" {
  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"

  name      = "csi-driver-nfs"
  chart     = "csi-driver-nfs"
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
