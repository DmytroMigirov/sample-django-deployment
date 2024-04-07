#### ec2 ####
resource "aws_launch_configuration" "ec2" {
  name                        = "${var.ec2_instance_name}-instances-lc"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = "${var.instance_type}"
  security_groups             = [aws_security_group.ec2.id]
  key_name                    = "${var.key_name}"
  iam_instance_profile        = aws_iam_instance_profile.session-manager.id
  associate_public_ip_address = false
  user_data = <<-EOL
  #!/bin/bash -xe
  apt update
  apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update
  apt install -y docker-ce docker-ce-cli containerd.io
  usermod -aG docker ubuntu
  systemctl start docker
  systemctl enable docker
  docker run -p 80:3000 ghcr.io/benc-uk/nodejs-demoapp:latest
  sudo apt-add-repository ppa:ansible/ansible -y
  sudo apt update -y
  sudo apt install ansible -y
  EOL
  depends_on = [aws_nat_gateway.terraform-lab-ngw]
  
}

resource "aws_instance" "postgres_instance" {
  ami                         = lookup(var.amis, var.region)
  instance_type               = "${var.instance_type}"
  security_groups             = [aws_security_group.postgres_sg.id]
  key_name                    = "${var.key_name}"
  iam_instance_profile        = aws_iam_instance_profile.session-manager.id
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private-subnet-1.id
  user_data = <<-EOL
  #!/bin/bash -xe
  apt-add-repository ppa:ansible/ansible -y
  apt update -y
  apt install ansible -y
  EOL
  tags = {
    Name = "PostgresInstance"
  }
}



#### Auto-scaling group ####
resource "aws_autoscaling_group" "ec2-cluster" {
  name                 = "${var.ec2_instance_name}_auto_scaling_group"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ec2.name
  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  target_group_arns    = [aws_alb_target_group.default-target-group.arn]
}
