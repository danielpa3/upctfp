
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    argocd = {
      source = "oboukili/argocd"
      version = "5.6.0"
    }
    acme = {
      source = "vancluever/acme"
      version = "2.15.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

data "aws_eks_cluster" "this" {  name = aws_eks_cluster.nom.name }

data "aws_eks_cluster_auth" "this" { name = data.aws_eks_cluster.this.name }

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  }
}

provider "argocd" {
  username = "admin"
  password = file("argocd_admin_password.txt")
  server_addr = local.argocd_server_addr
  insecure = true
  kubernetes {
    insecure = true
  }
}

