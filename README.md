# UPC TFP
## Entorno AWS EKS + ArgoCD + Crossplane

### Consideraciones
1. En variables.tf, cambiar el valor default de dominio para indicar el dominio donde estará apuntando el loadbalancer del servicio argocd-server

2. Revisar el tipo de nodos del cluster EKS en el archivo 7-nodes.tf, ahora lanza 3 instancias t3.small

3. El archivo argocd_admin_password.txt, ahora vacio despues de hacer apply guardará la contraseña de ArgoCD

4. Configurar las credenciales de AWS en ~/.aws/credentials (Si usas una cuenta Academy, AWS Details -> AWS CLI [Show] )



### Ahora, ejecutar terraform init
```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Finding latest version of hashicorp/helm...
- Finding latest version of hashicorp/kubernetes...
- Finding hashicorp/tls versions matching "4.0.4"...
- Finding hashicorp/aws versions matching "~> 3.0"...
- Finding oboukili/argocd versions matching "5.6.0"...
- Finding vancluever/acme versions matching "2.15.1"...
- Installing hashicorp/kubernetes v2.21.1...
- Installed hashicorp/kubernetes v2.21.1 (signed by HashiCorp)
- Installing hashicorp/tls v4.0.4...
- Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
- Installing hashicorp/aws v3.76.1...
- Installed hashicorp/aws v3.76.1 (signed by HashiCorp)
- Installing oboukili/argocd v5.6.0...
- Installed oboukili/argocd v5.6.0 (self-signed, key ID 09A6EABF546E8638)
- Installing vancluever/acme v2.15.1...
- Installed vancluever/acme v2.15.1 (self-signed, key ID F282F2CFA56C3D69)
- Installing hashicorp/null v3.2.1...
- Installed hashicorp/null v3.2.1 (signed by HashiCorp)
- Installing hashicorp/helm v2.10.1...
- Installed hashicorp/helm v2.10.1 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```



### ahora terraform apply

```
$ terraform apply
data.aws_caller_identity.current: Reading...
data.aws_caller_identity.current: Read complete after 0s [id=330632492714]
data.aws_eks_cluster_auth.this: Reading...
data.aws_eks_cluster_auth.this: Read complete after 0s [id=demo]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.aws_eks_cluster.this will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "aws_eks_cluster" "this" {
      + arn                       = (known after apply)
      + certificate_authority     = (known after apply)
      + created_at                = (known after apply)

[...]

  # null_resource.kubectl_get_admin_secret will be created
  + resource "null_resource" "kubectl_get_admin_secret" {
      + id = (known after apply)
    }

  # null_resource.update_kubeconfig will be created
  + resource "null_resource" "update_kubeconfig" {
      + id = (known after apply)
    }

Plan: 25 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.main: Creating...
aws_eip.nat: Creating...
aws_eip.nat: Creation complete after 1s [id=eipalloc-02ddc02b0ade89b82]
aws_vpc.main: Creation complete after 1s [id=vpc-0d2ca4ae26c901a4c]
aws_subnet.public-us-east-1a: Creating...
aws_subnet.private-us-east-1a: Creating...

[...]

null_resource.kubectl_crossplane_provider_wait: Creation complete after 2m0s [id=9004073190925373846]
null_resource.kubectl_crossplane_providerconfig: Creating...
null_resource.kubectl_crossplane_providerconfig: Provisioning with 'local-exec'...
null_resource.kubectl_crossplane_providerconfig (local-exec): Executing: ["/bin/sh" "-c" "kubectl apply -f crossplane_providerconfig.yaml"]
null_resource.kubectl_crossplane_providerconfig (local-exec): providerconfig.aws.upbound.io/default created
null_resource.kubectl_crossplane_providerconfig: Creation complete after 10s [id=966864286241888860]

Apply complete! Resources: 25 added, 0 changed, 0 destroyed.


```























