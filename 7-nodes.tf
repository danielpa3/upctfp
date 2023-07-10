resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.nom.name
  node_group_name = "private-nodes"
  node_role_arn   = local.labrole_arn

  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }
}
