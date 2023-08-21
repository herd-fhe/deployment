output "lb" {
  value = {
    id       = aws_lb.herd.id
    endpoint = aws_lb.herd.dns_name
  }
}