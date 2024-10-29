provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket for storing media files
resource "aws_s3_bucket" "netflix_media" {
  bucket = "netflix-clone-media"
  acl    = "private"
}

# Create an EC2 instance for hosting the backend
resource "aws_instance" "backend_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example AMI (Ubuntu)
  instance_type = "t2.micro"
  
  tags = {
    Name = "Netflix-Clone-Backend"
  }
}

# Create an RDS instance for database
resource "aws_db_instance" "netflix_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "netflixdb"
  username             = "admin"
  password             = "password"
  publicly_accessible  = false
  skip_final_snapshot  = true
}
