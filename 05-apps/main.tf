module "backend" {
    source  = "terraform-aws-modules/ec2-instance/aws"

    name = "${var.project_name}-${var.environment}-backend"

    instance_type          = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
    # convert StringList to list and get first element
    subnet_id              = local.private_subnet_id
    ami = data.aws_ami.ami_info.id
    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-backend"
        }
    )
}

module "frontend" {
    source  = "terraform-aws-modules/ec2-instance/aws"

    name = "${var.project_name}-${var.environment}-frontend"

    instance_type          = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
    # convert StringList to list and get first element
    subnet_id              = local.public_subnet_id
    ami = data.aws_ami.ami_info.id
    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-frontend"
        }
    )
}
module "records" {
    source  = "terraform-aws-modules/route53/aws//modules/records"
    version = "~> 3.0"

    zone_name = var.zone.name

    records = [
        {
        name    = "backend"
        type    = "A"
        ttl = 1
        records = [
            module.backend.private_ip,
        ]
        },
        {
        name    = ""
        type    = "A"
        ttl     = 3600
        records = [
            "10.10.10.10",
        ]
        },
    ]

    depends_on = [module.zones]
}