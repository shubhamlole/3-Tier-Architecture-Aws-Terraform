output "Endpoint" {
  description = "internet facing load balancer DNS"
  value = aws_lb.web_lb.dns_name
}