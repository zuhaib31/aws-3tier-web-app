
# rds needs subnets in 2+ azs
resource "aws_db_subnet_group" "main" {
  name       = "app-db-subnet-group"
  subnet_ids = [aws_subnet.db_a.id, aws_subnet.db_b.id]

  tags = {
    Name = "app-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "app-mysql-db"
  engine         = "mysql"
  engine_version = "8.4"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = "admin"

  # managed master password -> secrets manager, never in code or state
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  multi_az            = false
  publicly_accessible = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "3tier-mysql"
  }
}
