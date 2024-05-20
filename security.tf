resource "aws_security_group" "xotocross-allow-ssh" {
    name        = "xotocross-allow-ssh"
    description = "xotocross allow ssh inbound traffic"
    vpc_id    = module.xotocross-vpc.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "xotocross-k8-node-sg" {
    name = "xotocross-${var.xotocross-bucket-name}-k8-node-sg"
    description = "xotocross sec group for k8 nodes"
    vpc_id = module.xotocross-vpc.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_security_group" "xotocross-k8-masters-sg" {
    name = "xotocross-${var.xotocross-bucket-name}-k8-masters-sg"
    description = "xotocross sec group for k8 master nodes"
    vpc_id = module.xotocross-vpc.vpc_id

    # kubernetes api server
    ingress {
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    # etcd server client api
    ingress {
        from_port   = 2379
        to_port     = 2380
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    # kubelet api
    ingress {
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    # kube-scheduler
    ingress {
        from_port   = 10259
        to_port     = 10259
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    # kube-controller-manager
    ingress {
        from_port   = 10257
        to_port     = 10257
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }
  
}

resource "aws_security_group" "xotocross-k8-workers-sg" {
    name = "xotocross-${var.xotocross-bucket-name}-k8-workers-sg"
    description = "xotocross sec group for k8 worker nodes"
    vpc_id = module.xotocross-vpc.vpc_id

    # kubelet api
    ingress {
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }

    # nodeport services†
    ingress {
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        cidr_blocks = ["${var.xotocross-vpc-cidr}"]
    }
}