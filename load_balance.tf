

resource "aws_lb" "xotocross-k8-masters-load" {
    name = "xotocross-k8-masters-load"
    internal = true
    load_balancer_type = "network"
    subnets = module.xotocross-vpc.private_subnets #[for subnet in module.xotocross-vpc.private_subnets : subnet.id]
    tags = {
    Terraform = "true"
    Environment = "dev"
  }
  
}

# target_type instance not working well when we bound this LB as a control-plane-endpoint. hence had to use IP target_type
#https://stackoverflow.com/questions/56768956/how-to-use-kubeadm-init-configuration-parameter-controlplaneendpoint/70799078#70799078

resource "aws_lb_target_group" "xotocross-k8-masters-api" {
    name = "xotocross-k8-masters-api"
    port = 6443
    protocol = "TCP"
    vpc_id = module.xotocross-vpc.vpc_id
    target_type = "ip"

    health_check {
      port = 6443
      protocol = "TCP"
      interval = 30
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "xotocross-k8-masters-load-listener" {
    load_balancer_arn = aws_lb.xotocross-k8-masters-load.arn
    port = 6443
    protocol = "TCP"

    default_action {
        target_group_arn = aws_lb_target_group.xotocross-k8-masters-api.id
        type = "forward"
    }
}

resource "aws_lb_target_group_attachment" "xotocross-masters-attachment" {
    count = length(aws_instance.masters.*.id)
    target_group_arn = aws_lb_target_group.xotocross-k8-masters-api.arn
    target_id = aws_instance.masters.*.private_ip[count.index]
}
