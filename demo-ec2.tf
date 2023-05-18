resource "aws_instance" "demo-ec2" {
  ami           = "ami-08928044842b396f0"
  instance_type = "t３.micro"
  subnet_id     = "subnet-55676d23"

  tags = {
    Name = "demo-ec2-01"
  }

}
