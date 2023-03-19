resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public-subnet" {
  count                   = 3
  cidr_block              = cidrsubnet(aws_vpc.main-vpc.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.main-vpc.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assc" {
  count          = 3
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.rt.*.id, count.index)
}

resource "aws_security_group" "sg-http-ssh" {
  name   = "Allow HTTP and SSH from laptop"
  vpc_id = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}