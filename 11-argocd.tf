resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.36.10"
  namespace  = "default"

  values = [
    file("${path.module}/argocd.yaml")
  ]

  provisioner "local-exec" {
    command = "kubectl patch -n default service argocd-server -p '{\"spec\":{\"type\":\"LoadBalancer\"}}'"
  }
}

resource "null_resource" "kubectl_get_admin_secret" {
  provisioner "local-exec" {
    command = "kubectl -n default get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d > argocd_admin_password.txt "
  }
  depends_on = [helm_release.argocd]
}
