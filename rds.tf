resource "aws_db_subnet_group" "my_db_subnet_group" {
    name = "my_db_subnet_group"
  subnet_ids = [aws_subnet.rds_sub_1.id, aws_subnet.rds_sub_2.id]

  tags = {
    Name = "my_db_subnet_group"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  publicly_accessible  = false

  identifier = "mydb"
}
