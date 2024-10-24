resource "aws_security_group" "vpn_access" {
  name        = "${var.environment_name}-${var.component_name}-vpn-access"
  description = "Security group for VPN access"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_ec2_client_vpn_endpoint" "linuxtips_vpn" {
  client_cidr_block      = var.client_cidr_block
  server_certificate_arn = var.server_certificate_arn
  vpc_id                 = var.vpc_id
  security_group_ids     = [aws_security_group.vpn_access.id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.server_certificate_arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.vpn_logs.name
  }

  split_tunnel = true
}

resource "aws_ec2_client_vpn_network_association" "private_subnet_association" {
  count                  = length(var.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.linuxtips_vpn.id
  subnet_id              = var.private_subnets[count.index]
}

resource "aws_ec2_client_vpn_authorization_rule" "authorize_all" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.linuxtips_vpn.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
  description            = "Rule to authorize all groups"
}

resource "aws_cloudwatch_log_group" "vpn_logs" {
  name              = "/vpn/${var.environment_name}-${var.component_name}/${var.component_name}"
  retention_in_days = 30
}
