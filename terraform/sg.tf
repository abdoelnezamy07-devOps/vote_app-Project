    resource "aws_security_group" "ALBSG" {
    name        = "ALBSG"
    vpc_id      = aws_vpc.vote-app.id ##
    }

    resource "aws_security_group" "public-SG" {
    name        = "webSG"
    vpc_id      = aws_vpc.vote-app.id
    }
    resource "aws_security_group" "private-SG" {
    name        = "dataSG"
    vpc_id      = aws_vpc.vote-app.id ##
    }

    resource "aws_security_group_rule" "alb_inbound" {
        from_port = 80
        to_port = 80
        type = "ingress"
        protocol = "tcp"
        security_group_id = aws_security_group.ALBSG.id
        cidr_blocks = ["0.0.0.0/0"]
    }
    resource "aws_security_group_rule" "alb_outbound" {
        from_port = 32000
        to_port = 32000
        type = "egress"
        protocol = "tcp"
        security_group_id = aws_security_group.ALBSG.id
        source_security_group_id = aws_security_group.private-SG.id
    }
    # resource "aws_security_group_rule" "alb_outbound1" {
    # type              = "egress"
    # from_port         = 0
    # to_port           = 0
    # protocol          = "-1" 
    # security_group_id = aws_security_group.ALBSG.id
    # cidr_blocks       = [var.Cidr_block] 
    # }

    resource "aws_security_group_rule" "public_inbound_SSH" {
        type              = "ingress"
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        security_group_id = aws_security_group.public-SG.id
        cidr_blocks       = ["0.0.0.0/0"]
    }
    resource "aws_security_group_rule" "public_outbound_SSH" {
        type              = "egress"
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        security_group_id = aws_security_group.public-SG.id
        source_security_group_id = aws_security_group.private-SG.id
    }


    resource "aws_security_group_rule" "private_outbound_all" {
        type              = "egress"
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        security_group_id = aws_security_group.private-SG.id
        cidr_blocks       = ["0.0.0.0/0"]
    }

    resource "aws_security_group_rule" "private_inbound-nodePort" {
        from_port = 32000
        to_port = 32000
        type = "ingress"
        protocol = "tcp"
        security_group_id = aws_security_group.private-SG.id
        source_security_group_id = aws_security_group.ALBSG.id
    }
    resource "aws_security_group_rule" "private_inbound" {
        from_port = 0
        to_port = 0
        type = "ingress"
        protocol = "-1"
        security_group_id = aws_security_group.private-SG.id
        self = true
    }
     

    resource "aws_security_group_rule" "private_inbound_vpc_all" {
        type = "ingress"
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_group_id = aws_security_group.private-SG.id
        cidr_blocks = [var.Cidr_block] 
    }

    resource "aws_security_group_rule" "private_inbound-Svc" {
        for_each = toset(var.outbound_alb)
        from_port = each.value
        to_port = each.value
        type = "ingress"
        protocol = "tcp"
        security_group_id = aws_security_group.private-SG.id
        cidr_blocks = [var.Cidr_block]
    }
   
    resource "aws_security_group_rule" "private_inbound-dns" {
        for_each = var.dns
        from_port = each.value
        to_port = each.value
        type = "ingress"
        protocol = each.key
        security_group_id = aws_security_group.private-SG.id
        self = true
    }
    resource "aws_security_group_rule" "private_inbound-SSH" {
        from_port = 22
        to_port = 22
        type = "ingress"
        protocol = "tcp"
        security_group_id = aws_security_group.private-SG.id
        source_security_group_id = aws_security_group.public-SG.id
    }
    
    
