data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}


output "availability_zones" {
  description = "availability zones in region" 
  value       = data.aws_availability_zones.available
}



# # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
# data "aws_eks_cluster" "default" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "default" {
#   name = module.eks.cluster_id
# }