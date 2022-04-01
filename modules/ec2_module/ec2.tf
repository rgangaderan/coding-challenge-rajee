locals {
  name_prefix = "${var.name_prefix}_${var.environment}"
  bastion     = "Bastion_Host"
  private     = "Private_Host"

}

resource "aws_iam_role" "ec2_iam_role" {
  name = "${local.name_prefix}_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = local.name_prefix
  }
}

resource "aws_iam_role_policy" "secretmanager_policy" {
  name = "${local.name_prefix}_policy"
  role = aws_iam_role.ec2_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "*"
    }]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${local.name_prefix}_instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_instance" "ec2_private" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = lookup(var.instance_type, var.environment, "instance type not allowed!")
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.security_group_private.id]

  tags = {
    Name = local.private
  }
}
resource "aws_instance" "ec2_bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = lookup(var.instance_type, var.environment, "instance type not allowed!")
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.security_group_public.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt update && sudo apt install awscli -y",
      "aws secretsmanager --output text get-secret-value --secret-id ${element(var.secret_name, 0)}-${var.environment} --query SecretString --region ${var.region} > ${var.key_name}.pem",
      "sudo chmod 400 ${var.key_name}.pem",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.secret_string
    host        = self.public_ip
  }

  tags = {
    Name = local.bastion
  }
}
