# --- Security Group for SSH (intentionally wrong first) ---
resource "aws_security_group" "sre_lab_sg" {
  name        = "sre-capstone-ssh-sg"
  description = "SRE capstone: SSH access for connectivity lab"
  vpc_id      = module.vpc.vpc_id

  # OUTBOUND: allow all egress (common default for troubleshooting)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sre-capstone-ssh-sg"
  }
}

# INBOUND SSH - intentionally WRONG CIDR (so SSH will fail first)
resource "aws_vpc_security_group_ingress_rule" "ssh_in_wrong" {
  security_group_id = aws_security_group.sre_lab_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "72.82.27.107/32" # WRONG on purpose (your home IP is not in this range)
  description       = "INTENTIONALLY_WRONG simulate SSH timeout"
}

# Find latest Amazon Linux 2023 AMI in us-east-1
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }
}

# --- EC2 instance in PUBLIC subnet ---
resource "aws_instance" "sre_lab_ec2" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.sre_lab_sg.id]
  associate_public_ip_address = true

  key_name = "sre-capstone-key" # MUST match your AWS key pair name

  tags = {
    Name = "sre-capstone-ec2-public"
  }
}

output "ec2_public_ip" {
  value = aws_instance.sre_lab_ec2.public_ip
}
