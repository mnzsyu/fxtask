resource "aws_instance" "knode" {
  count         = 3
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = aws_subnet.public-subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.sg-http-ssh.id]
  associate_public_ip_address = true

  tags = {
    "Name" : "${format("knode-%d", count.index + 1)}"
  }
}
