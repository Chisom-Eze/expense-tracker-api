resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.name_prefix}-ecs-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"

  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_description = "ECS CPU utilization too high"

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "${var.name_prefix}-ecs-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"

  
  period              = 60
  statistic           = "Average"
  threshold           = 75

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_description = "ECS memory utilization too high"

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.cluster_name,
              "ServiceName",
              var.service_name
            ]
          ]

          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "ECS CPU Utilization"
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.cluster_name,
              "ServiceName",
              var.service_name
            ]
          ]

          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "ECS Memory Utilization"
        }
      }
    ]
  })
}