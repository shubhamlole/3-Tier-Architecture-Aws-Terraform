variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  default     = "admin1234"
  sensitive   = true
}

variable "ingress_rules" {
  type = list(number)
  default = [ 22, 80 ]
}