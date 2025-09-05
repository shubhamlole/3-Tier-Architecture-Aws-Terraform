resource "aws_lb_target_group" "app_tg" {
  name = "app-tg"
  target_type = "instance"
  protocol = "HTTP"
  port = 4000
  vpc_id = aws_vpc.my_vpc.id

  health_check {
    enabled = true
    interval = 30
    path = "/health"
    timeout = 10
    healthy_threshold = 3
    unhealthy_threshold = 5

  }
  tags = {
    Name = "app_tg"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"                   
  target_type = "instance"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.my_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }

  tags = {
    Name = "web_tg"                        
  }
}
