data "aws_ami" "ubuntu" {
  region = var.aws_region
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
output "ami-id" {
  value = data.aws_ami.ubuntu.image_id
}

resource "aws_key_pair" "k8s_key" {
  key_name   = "abdo-key"
  public_key = file("../abdo-key.pub") 
}

# --- Bastion Host Node ---
resource "aws_instance" "Bastion" {
  ami           = data.aws_ami.ubuntu.image_id 
  instance_type = "t3.micro"             
  subnet_id     = aws_subnet.public_subnet["us-east-1a"].id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.public-SG.id]
  key_name               = aws_key_pair.k8s_key.key_name
  tags = {
    Name = "Bastion"
  }
}


# --- 1. الـ Master Node ---
resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu.image_id 
  instance_type = "t3.medium"             
  subnet_id     = aws_subnet.private_subnet["us-east-1a"].id
 root_block_device {
    delete_on_termination = true
    volume_size = 30
  }
  iam_instance_profile = aws_iam_instance_profile.k8s_profile.name

  vpc_security_group_ids = [aws_security_group.private-SG.id]
  key_name               = aws_key_pair.k8s_key.key_name
  user_data = file("setup-M.sh")
  tags = {
    Name = "k8s-master"
  }
  depends_on = [ aws_nat_gateway.tf_nat ]
}


# --- 2. الـ Worker Nodes ---
resource "aws_instance" "workers" {

  for_each      = aws_subnet.private_subnet
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t3.large"
  subnet_id     = each.value.id
  root_block_device {
    delete_on_termination = true
    volume_size = 30
  }
  iam_instance_profile = aws_iam_instance_profile.k8s_profile.name

  vpc_security_group_ids = [aws_security_group.private-SG.id]
  key_name               = aws_key_pair.k8s_key.key_name
  user_data = file("setup-W.sh")
  tags = {
    Name = "k8s-worker-${each.key}" 
  }
  depends_on = [ aws_nat_gateway.tf_nat ]
}


# data "aws_iam_role" "name_role" {
#   name = "ebs-" 
# }

resource "aws_iam_instance_profile" "k8s_profile" {
  role = "ebs-"
}



output "bastion_public_ip" {
  value = aws_instance.Bastion.public_ip
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}
output "workers_private_ips" {
  value = { for k, instance in aws_instance.workers : k => instance.private_ip }
}
output "ssh_to_bastion" {
  value = "ssh -A ubuntu@${aws_instance.Bastion.public_ip}"
}
