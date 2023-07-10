variable "eks_name" {
  description = "Define el nombre del cluster EKS - será parte de la URL para acceder a ArgoCD"
  default     = "demo"
}

variable "dominio" {
  description = "Dominio donde está publicado ArgoCD - Recuerda en Route53 crear una entrada al LoadBalancer de ArgoCD-server"
  default = "XXXXXX.XXX"
}

locals {
   argocd_server_addr = "argocd.${var.eks_name}.${var.dominio}"
}

