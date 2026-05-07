resource "aws_lb" "app" {
    name               = "expense-alb"
    internal           = false
    load_balancer_type = "application"
    subnets            = data.aws_subnets.default.ids
    security_groups    = [aws_security_group.alb_sg.id]
}


resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_target_group" "app" {
    name     = "expense-tg"
    port     = 8000
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id
    target_type = "ip"

    health_check {
        path                = "/docs"
        port                = "8000"
       
    }
}


resource "aws_lb_listener" "app" {
    load_balancer_arn = aws_lb.app.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app.arn
    }
}