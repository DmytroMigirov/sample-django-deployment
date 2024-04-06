output "alb_dns_name" {
  value = aws_lb.terraform-lab.dns_name
}

output "postgres_instance_ip" {
  value = aws_instance.postgres_instance[*].private_ip
}

