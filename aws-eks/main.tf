provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::803230064786:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS" // Replace with your IAM role ARN

  vpc_config {
    subnet_ids = ["subnet-0877e9efcffbd4df9", "subnet-001c231b17c728057"] // Replace with your subnet IDs
    security_group_ids = ["sg-3509ac18"] // Replace with your security group IDs
  }
}

data "aws_eks_cluster" "my_cluster" {
  name = aws_eks_cluster.my_cluster.name
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = data.aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = "arn:aws:iam::123456789012:role/eks-node-role" // Replace with your IAM role ARN

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = "your_ssh_key_name" // Replace with your SSH key name
    source_security_group_ids = ["sg-12345678"] // Replace with your security group IDs
  }

  subnet_ids = ["subnet-12345678", "subnet-23456789"] // Replace with your subnet IDs
}
