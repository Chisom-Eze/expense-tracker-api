resource "aws_db_subnet_group" "main" {
  name       = "${var.name_prefix}-db-subnet-group"

  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.ecs_security_group_id]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
 
}


resource "aws_db_instance" "postgres" {
  identifier              = "${var.name_prefix}-db-instance"
 
  engine                  = "postgres"
  engine_version          = "15"

  instance_class          = "db.t3.micro"
  
  storage_type            = "gp2"
  allocated_storage       = 20

  username                = var.db_username
  password                = var.db_password
  
  db_name                 = var.db_name

  publicly_accessible     = false

  skip_final_snapshot     = true


  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [
    aws_security_group.rds_sg.id
 ]

  tags = var.tags
}
