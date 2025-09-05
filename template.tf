resource "aws_launch_template" "app_template" {
  name = "app_template"
  image_id = "ami-02d26659fd82cf299"
  instance_type = "t3.micro"
  key_name = "duplicate"
  vpc_security_group_ids = [ aws_security_group.app_tier_sg.id ]

  user_data = base64encode(
  templatefile("${path.module}/app.sh.tpl", {
    db_endpoint = aws_db_instance.mydb.address   # ✅ use .address, not .endpoint
    db_username = var.db_username
    db_password = var.db_password
  })
)

}

resource "aws_launch_template" "web_template" {
  name          = "web_template"
  image_id      = "ami-02d26659fd82cf299"   
  instance_type = "t3.micro"
  key_name      = "duplicate"               

  network_interfaces {
    associate_public_ip_address = true   # ✅ ensures public IP
    security_groups             = [aws_security_group.web-sg.id]
  }

  user_data = base64encode(
    templatefile("${path.module}/web.sh.tpl", {
      internal_lb_dns = aws_lb.app_lb.dns_name
    })
  )
}


