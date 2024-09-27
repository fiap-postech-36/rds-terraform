provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  arn        = ""arn:aws:iam::013545085409:role/LabRole"

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subnet2"
  }
}

resource "aws_security_group" "default" {
  name        = "rds_security_group"
  description = "Allow access to RDS instance"
  vpc_id     = aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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

resource "aws_db_subnet_group" "default" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "My RDS Subnet Group"
  }

   lifecycle {
    prevent_destroy = true  # Impede que o Terraform destrua o grupo de sub-redes
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine             = "postgres"
  engine_version     = "15"
  instance_class     = "db.t3.micro"
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.default.id]
  multi_az           = false
  storage_type       = "gp2"
  skip_final_snapshot = true
}
