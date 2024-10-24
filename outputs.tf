output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN Endpoint"
  value       = aws_ec2_client_vpn_endpoint.linuxtips_vpn.id
}
