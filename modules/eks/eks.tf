resource "aws_eks_cluster" "eks_cluster" {

    name    = var.cluster_name
    version = var.k8s_version
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {

        security_group_ids = [
            aws_security_group.cluster_master_sg.id
        ]

        subnet_ids = [
            var.private_subnet_1a.id,
            var.private_subnet_1c.id
        ]

    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }

}
resource "aws_eks_node_group" "cluster" {
  
    cluster_name = var.eks_cluster.name
    node_group_name = format("%s-node-group", var.cluster_name)
    node_role_arn = aws_iam_role.eks_nodes_roles.arn

    subnet_ids = [
        var.private_subnet_1a.id,
        var.private_subnet_1c.id
    ]

    instance_types = var.nodes_instances_sizes

    scaling_config {
        desired_size    = lookup(var.auto_scale_options, "desired")
        max_size        = lookup(var.auto_scale_options, "max")
        min_size        = lookup(var.auto_scale_options, "min")
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }

}
