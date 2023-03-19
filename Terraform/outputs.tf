output "instance_ips" {
  value = aws_instance.knode.*.public_ip
}