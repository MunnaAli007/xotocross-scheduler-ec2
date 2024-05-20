#Bastion
resource "aws_instance" "xotocross-bastion" {
  ami           = var.ami["default"] 
  instance_type = "t3.micro"
  subnet_id = module.xotocross-vpc.public_subnets[0]
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.xotocross-allow-ssh.id]
  key_name          =   aws_key_pair.xotocross-k8-ssh.key_name
  user_data = <<-EOF
                #!bin/bash
                echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
                systemctl reload sshd
                PATH="/home/ubuntu/.ssh/id_rsa"
                echo "${tls_private_key.xotocross-ssh.private_key_pem}" >> $PATH
                chown ubuntu $PATH && chgrp ubuntu $PATH && chmod 600 $PATH
                apt-add-repository ppa:ansible/ansible -y && apt update && apt install ansible -y
                EOF

  tags = {
    Name = "xotocross-${var.xotocross-bucket-name}-bastion"
  }
}

#Master
resource "aws_instance" "masters" {
  count         = var.xotocross-master-node-count
  ami           = var.ami["default"] 
  instance_type = var.xotocross-master-instance-type
  subnet_id = "${element(module.xotocross-vpc.private_subnets, count.index)}"
  key_name          =   aws_key_pair.xotocross-k8-ssh.key_name
  security_groups = [aws_security_group.xotocross-k8-node-sg.id, aws_security_group.xotocross-k8-masters-sg.id]

  tags = {
    Name = format("Master-%02d", count.index + 1)
  }
}

#Worker
resource "aws_instance" "workers" {
  count         = var.xotocross-worker-node-count
  ami           = var.ami["default"] 
  instance_type = var.xotocross-worker-instance-type
  subnet_id = "${element(module.xotocross-vpc.private_subnets, count.index)}"
  key_name          =   aws_key_pair.xotocross-k8-ssh.key_name
  security_groups = [aws_security_group.xotocross-k8-node-sg.id, aws_security_group.xotocross-k8-workers-sg.id]

  tags = {
    Name = format("Worker-%02d", count.index + 1)
  }
}