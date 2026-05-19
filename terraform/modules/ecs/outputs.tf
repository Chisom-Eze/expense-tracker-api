output "cluster_name" {
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  value       = aws_ecs_service.app.name
}

output "service_arn" {
  value       = aws_ecs_service.app.arn
}

output "ecs_security_group_id" {
  value       = aws_security_group.ecs_sg.id
}
