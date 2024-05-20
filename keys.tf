resource "tls_private_key" "xotocross-ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "xotocross-k8-ssh-key" {
    filename = "xotocross-k8-ssh-key.pem"
    file_permission = "600"
    content  = tls_private_key.xotocross-ssh.private_key_pem
}

resource "aws_key_pair" "xotocross-k8-ssh" {
  key_name   = "xotocross-k8-ssh"
  public_key = tls_private_key.xotocross-ssh.public_key_openssh
}