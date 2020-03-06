# Uncomment resources below and add required arguments.

resource "aws_security_group" "ec2" {
  # 1. Define logical names (identifiers) for resource.
  #    E.g.: resource "type" "resource_logical_name" {}
  #    Docs: https://www.terraform.io/docs/providers/aws/r/security_group.html

  # 2. Set pysical name of your security group below in format "yourname-"
  name = "ec2"

  description = "Test security group."
  vpc_id = "vpc-c0648ab9"
}

# To reference attributes of resources use syntax TYPE.NAME.ATTRIBUTE
#   for example, in order to create rule in specific secrurity group you will have to
#   refer security group by its name :
#     security_group_id = "${aws_security_group.mysecuritygroup.id}"
#
# Reference: https://www.terraform.io/docs/configuration/interpolation.html


resource "aws_security_group_rule" "ssh_ingress_access" {
  # 1. Add required arguments to open ingress(incoming) traffic to TCP port 22 - we'll use it later to ssh into instance.
  # 2. Add argument to reference Security Group resource.
  # Docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
  
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks = [ "172.31.0.0/16" ] 
}

resource "aws_security_group_rule" "egress_access" {
  # 1. Add required arguments to open outgoing traffic to all ports (0-65535) 
  # 2. Add argument to reference Security Group resource.
  # Docs: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
  
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks = [ "172.31.0.0/16" ] 
}

resource "aws_instance" "ec2" {
  # 1. Add resource name.
  # 2. Specify VPC subnet ID
  # 3. Specify EC2 instance type.
  # 4. Specify Security group for this instance (use one that we create above).
  # Docs: https://www.terraform.io/docs/providers/aws/r/instance.html

  subnet_id = "subnet-37b5ee51"

  instance_type = "t2.nano"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  associate_public_ip_address = false
  # user_data = "${file("../shared/user-data.txt")}"
  tags {
    Name = "w1-ec2-instance"
  }
  
  # Keep these arguments as is:
  ami = "ami-cb2305a1"
  availability_zone = "us-east-1c"
}

