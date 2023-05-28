variable "lb_ip_range" {
  description = "Range of IPs to use for the MetalLB load balancer"
  type        = string
  default     = "10.8.240.0/20"
}