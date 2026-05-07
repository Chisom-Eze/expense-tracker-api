resource "aws_db_subnet_group" "default" {
  name       = "expense-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}


resource "aws_security_group" "rds_sg" {
    name        = "rds-sg"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        security_groups = [aws_security_group.ecs_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_db_instance" "postgres" {
    identifier              = "expense-db"

    engine                  = "postgres"
    engine_version          = "15"
    instance_class          = "db.t3.micro"

    allocated_storage       = 20

    username               = "postgres"
    password               = "postgres123"

    db_name                 = "expense_db"

    publicly_accessible      = false
    skip_final_snapshot     = true

    vpc_security_group_ids  = [aws_security_group.rds_sg.id]
    db_subnet_group_name    = aws_db_subnet_group.default.name
}