resource "aws_ecs_task_definition" "app" {
  family                   = "expense-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

 container_definitions = jsonencode([
  {
    name  = "expense-container"
    image = var.container_image

    essential = true

     environment = [
      {
        name  = "DATABASE_URL"
        value = "postgresql://postgres:postgres123@expense-db.c054yka6y3lz.us-east-1.rds.amazonaws.com:5432/expense_db"
      }
    ]

    portMappings = [
      {
        containerPort = 8000
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/expense-tracker"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }
])
}