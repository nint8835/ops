resource "helm_release" "nfs_csi" {
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
