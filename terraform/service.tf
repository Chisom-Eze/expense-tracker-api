resource "aws_ecs_service" "app"{
name            = "expense-service"
cluster         = aws_ecs_cluster.main.id
task_definition = aws_ecs_task_definition.app.arn
launch_type    = "FARGATE"
desired_count   = 1

network_configuration {
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "expense-container"
    container_port   = 8000
  }
}
