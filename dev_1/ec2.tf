# ---------------------------
# EC2 Key pair
# ---------------------------
variable "key_name" {
  default = "vook-rails-1-ssh-key-for-duplicated"
}

# 秘密鍵のアルゴリズム設定
resource "tls_private_key" "vook_rails_1_ssh_key_private" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# クライアントPCにKey pair（秘密鍵と公開鍵）を作成
# - Windowsの場合はフォルダを"\\"で区切る（エスケープする必要がある）
# - [terraform apply] 実行後はクライアントPCの公開鍵は自動削除される
locals {
  public_key_file  = ".ssh/${var.key_name}.id_rsa.pub"
  private_key_file = ".ssh/${var.key_name}.id_rsa"
}

resource "local_file" "vook_rails_1_ssh_key_private_pem" {
  filename = local.private_key_file
  content  = tls_private_key.vook_rails_1_ssh_key_private.private_key_pem
}

# 上記で作成した公開鍵をAWSのKey pairにインポート
resource "aws_key_pair" "vook_rails_1_ssh_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.vook_rails_1_ssh_key_private.public_key_openssh
}

# ---------------------------
# EC2
# ---------------------------
# Amazon Linux 2 の最新版AMIを取得
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# EC2作成
resource "aws_instance" "vook-rails-1-web" {
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = var.az_a
  vpc_security_group_ids      = [aws_security_group.vook_rails_1_sg.id]
  subnet_id                   = aws_subnet.vook_rails_1_public_subnet_1a.id
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  tags = {
    Name = "vook-rails-1-web"
  }
}
