resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}
resource "aws_subnet" "pub_sub_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub_sub_1"
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub_sub_2"
  }
}

resource "aws_subnet" "pvt_sub_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pvt_sub_1"
  }
}
resource "aws_subnet" "pvt_sub_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pvt_sub_2"
  }
}

resource "aws_subnet" "rds_sub_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-south-1c"

  tags = {
    Name = "rds_sub_1"
  }
}

resource "aws_subnet" "rds_sub_2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "rds_sub_2"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "public_rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}
resource "aws_route_table_association" "pub_rt_association1" {
  subnet_id = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "pub_rt_association2" {
  subnet_id = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
  tags = {
    Name = "nat_eip"
  }
}
resource "aws_nat_gateway" "my_ngw" {
    allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.pub_sub_1.id
}

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "pvt_rt"
  }

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_ngw.id

  }

}

resource "aws_route_table_association" "pvt_rt_association1" {
  subnet_id = aws_subnet.pvt_sub_1.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_route_table_association" "pvt_rt_association2" {
  subnet_id = aws_subnet.pvt_sub_2.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_route_table_association" "pvt_rt_association3" {
  subnet_id = aws_subnet.rds_sub_1.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_route_table_association" "pvt_rt_association4" {
  subnet_id = aws_subnet.rds_sub_2.id
  route_table_id = aws_route_table.pvt_rt.id
}
