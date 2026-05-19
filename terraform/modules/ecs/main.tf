resource "aws_ecs_cluster" "main" {
    name = "${var.name_prefix}-cluster"

    tags = var.tags
}


resource "aws_cloudwatch_log_group" "ecs" {
    name = "/ecs/${var.name_prefix}-logs"
    retention_in_days = 7
    
    tags = var.tags
}


resource "aws_ecs_task_definition" "app" {
  family                   = "${var.name_prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                      = "256"
  memory                   = "512"

execution_role_arn       = var.execution_role_arn
task_role_arn          = var.task_role_arn

 container_definitions = jsonencode([
  {
    name  = "expense-container"
    image = "${var.ecr_repository_url}:bootstrap"

    essential = true

    secrets = [
  {
    name      = "DATABASE_URL"
    valueFrom = var.database_url_secret_arn
  },
  {
    name      = "SECRET_KEY"
    valueFrom = var.secret_key_secret_arn
  }
    ]

    portMappings = [
      {
        containerPort = 8000
        hostPort      = 8000
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"

      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }
])

tags = var.tags
}


resource "aws_security_group" "ecs_sg" {
  name   = "${var.name_prefix}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_ecs_service" "app"{
name            = "${var.name_prefix}-service"
cluster         = aws_ecs_cluster.main.id
task_definition = aws_ecs_task_definition.app.arn

launch_type    = "FARGATE"

desired_count   = 1

network_configuration {
    subnets = var.subnet_ids
    security_groups = [var.alb_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "expense-container"
    container_port   = 8000
  }

depends_on = [
  aws_ecs_task_definition.app
]

 tags = var.tags
}

