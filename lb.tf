resource "aws_lb" "app_lb" {
  name = "app-lb"
  internal = true
  load_balancer_type = "application"
  security_groups = [ aws_security_group.internal_facing_alb_sg.id ]
  subnets = [ aws_subnet.pvt_sub_1.id, aws_subnet.pvt_sub_2.id ]
  
  tags = {
    Name = "app_lb"
  }
}

resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false                           
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internet_facing_alb_sg.id]
  subnets            = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]  

  tags = {
    Name = "web_lb"
  }
}
