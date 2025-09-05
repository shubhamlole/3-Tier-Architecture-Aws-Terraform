resource "aws_security_group" "internet_facing_alb_sg" {
  name = "internet_facing_alb_sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_security_group" "web-sg" {
  name = "web-tier-sg"
  vpc_id = aws_vpc.my_vpc.id
  description = "allow traffic from internet facing load balancer"

  dynamic "ingress" {
    for_each = var.ingress_rules
    
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}


   

resource "aws_security_group" "internal_facing_alb_sg" {
  name = "internal_facing_alb_sg"
  vpc_id = aws_vpc.my_vpc.id
  description = "allow traffic from web tier"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.web-sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_tier_sg" {
  name = "app_tier_sg"
  vpc_id = aws_vpc.my_vpc.id
  description = "allow traffic from internal facing load balancer"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.web-sg.id]
  }
   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    security_groups = [aws_security_group.internal_facing_alb_sg.id]
  }
   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "rds_sg" {
   name = "rds_sg"
  vpc_id = aws_vpc.my_vpc.id
  description = "allow traffic from app tier"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_tier_sg.id]
  }

  egress {
    from_port = "0"
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}