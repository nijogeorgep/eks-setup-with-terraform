module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI                    = "true"
          ENABLE_PREFIX_DELEGATION          = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
        nodeAgent = {
          enablePolicyEventLogs = "true"
        }
        enableNetworkPolicy = "true"
      })
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_cluster_security_group = false
  create_node_security_group    = false

  node_security_group_additional_rules = {
    ingress_15017 = {
      description                   = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
      protocol                      = "TCP"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_15012 = {
      description                   = "Cluster API to nodes ports/protocols"
      protocol                      = "TCP"
      from_port                     = 15012
      to_port                       = 15012
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    default = {
      instance_types           = ["m5.large"]
      force_update_version     = true
      release_version          = var.ami_release_version
      use_name_prefix          = false
      iam_role_name            = "${var.cluster_name}-ng-default"
      iam_role_use_name_prefix = false

      min_size     = 3
      max_size     = 6
      desired_size = 3

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        cluster-default = "yes"
        instance_types = "GeneralPurpose"
      }
    },
    compute = {
      instance_types           = ["c5.large"]
      force_update_version     = true
      release_version          = var.ami_release_version
      use_name_prefix          = false
      iam_role_name            = "${var.cluster_name}-compute-default"
      iam_role_use_name_prefix = false

      min_size     = 3
      max_size     = 6
      desired_size = 3

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        cluster-default = "no"
        instance_types = "ComputeOptmized"
      }
    }
  }

  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}
