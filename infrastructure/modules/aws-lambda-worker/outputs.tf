output "lambda_sg_id" {
  value = aws_security_group.herd_worker_lambda.id
}

output "lambda_alb_dns_name" {
  value = aws_alb.herd_worker.dns_name
}