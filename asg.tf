resource "aws_autoscaling_group" "app_asg" {
    depends_on = [ aws_db_instance.mydb, aws_lb_target_group.app_tg ]
  name = "app_asg"
  desired_capacity = 1
  min_size = 1
  max_size = 2
  vpc_zone_identifier = [ aws_subnet.pvt_sub_1.id, aws_subnet.pvt_sub_2.id ]
  health_check_type = "ELB"
  health_check_grace_period = 60

  launch_template {
    id = aws_launch_template.app_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key = "Name"
    value = "app_instance" 
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  depends_on = [aws_lb_target_group.web_tg]

  name                      = "web_asg"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]  
  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "web_instance"
    propagate_at_launch = true
  }
}
