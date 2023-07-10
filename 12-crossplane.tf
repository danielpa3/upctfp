resource "kubernetes_namespace" "crossplane_namespace" {
  metadata {
    name = "crossplane-system"
  }
}

resource "helm_release" "crossplane" {
  name       = "crossplane"
  repository = "https://charts.crossplane.io/stable"
  chart      = "crossplane"
  namespace  = kubernetes_namespace.crossplane_namespace.metadata[0].name

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
  depends_on = [kubernetes_namespace.crossplane_namespace]
}

resource "null_resource" "kubectl_aws_secret_crossplane" {
  provisioner "local-exec" {
    command = "kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=/home/ubuntu/.aws/credentials"
  }
  depends_on = [helm_release.crossplane]
}

resource "null_resource" "kubectl_crossplane_provider" {
  provisioner "local-exec" {
    command = "kubectl apply -f crossplane_provider.yaml"
  }
  depends_on = [null_resource.kubectl_aws_secret_crossplane]
}

resource "null_resource" "kubectl_crossplane_provider_wait" {
  provisioner "local-exec" {
    command = "sleep 120"  
  }
  depends_on = [null_resource.kubectl_crossplane_provider]
}

resource "null_resource" "kubectl_crossplane_providerconfig" {
  provisioner "local-exec" {
    command = "kubectl apply -f crossplane_providerconfig.yaml"
  }
  depends_on = [null_resource.kubectl_crossplane_provider_wait]
}

