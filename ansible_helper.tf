
resource "local_file" "xotocross-ansible-inventory" {
    content = templatefile("${path.root}/templates/inventry.tftpl",
        {
            masters-dns = aws_instance.masters.*.private_dns,
            masters-ip = aws_instance.masters.*.private_ip,
            masters-id = aws_instance.masters.*.id,
            workers-dns = aws_instance.workers.*.private_dns,
            workers-ip = aws_instance.workers.*.private_ip,
            workers-id = aws_instance.workers.*.id
        }    
    )
    filename = "${path.root}/inventory"
}

# TODO: Need to switch to signaling based solution instead of waiting. 
resource "time_sleep" "xotocross-wait-bastion" {
  depends_on = [aws_instance.xotocross-bastion]
  create_duration = "120s"
  triggers = {
    "always_run" = timestamp()
  }
}


resource "null_resource" "xotocross-provisioner" {
  depends_on = [
    local_file.xotocross-ansible-inventory,
    time_sleep.xotocross-wait-bastion,
    aws_instance.xotocross-bastion
    ]

  triggers = {
    "always_run" = timestamp()
  }

  provisioner "file" {
    source = "${path.root}/inventory"
    destination = "/home/ubuntu/inventory"

    connection {
      type = "ssh"
      host = aws_instance.xotocross-bastion.public_ip
      user = var.xotocross-ssh-user
      private_key = tls_private_key.xotocross-ssh.private_key_pem
      agent = false
      insecure = true
    }
  }
}

resource "local_file" "xotocross-variable-file" {
    content = <<-DOC
        master_lb: ${aws_lb.xotocross-k8-masters-load.dns_name}
        DOC
    filename = "ansible/xotocross-variable-file.yml"
}

resource "null_resource" "xotocross-copy-playbook" {
  depends_on = [
    null_resource.xotocross-provisioner,
    time_sleep.xotocross-wait-bastion,
    aws_instance.xotocross-bastion,
    local_file.xotocross-variable-file
    ]

  triggers = {
    "always_run" = timestamp()
  }

  provisioner "file" {
      source = "${path.root}/ansible"
      destination = "/home/ubuntu/ansible/"

      connection {
        type = "ssh"
        host = aws_instance.xotocross-bastion.public_ip
        user = var.xotocross-ssh-user
        private_key = tls_private_key.xotocross-ssh.private_key_pem
        insecure = true
        agent = false
      }
    
  }
}

resource "null_resource" "xotocross-run-ansible" {
  depends_on = [
    null_resource.xotocross-provisioner,
    null_resource.xotocross-copy-playbook,
    aws_instance.masters,
    aws_instance.workers,
    module.xotocross-vpc,
    aws_instance.xotocross-bastion,
    time_sleep.xotocross-wait-bastion
  ]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type = "ssh"
    host = aws_instance.xotocross-bastion.public_ip
    user = var.xotocross-ssh-user
    private_key = tls_private_key.xotocross-ssh.private_key_pem
    insecure = true
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60 && ansible-playbook -i /home/ubuntu/inventory /home/ubuntu/ansible/play.yml ",
    ] 
  }
}