output "Endpoint" {
  description = "internet facing load balancer DNS"
  value = aws_lb.web_lb.dns_name
}
output "RdsEndpoint" {
  description = "rds instance endpoint"
  value = aws_db_instance.mydb.endpoint
}