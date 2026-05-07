resource "aws_ecs_cluster" "main" {
    name = "${var.project_name}-cluster"
}


resource "aws_cloudwatch_log_group" "ecs" {
    name = "/ecs/expense-tracker"
}