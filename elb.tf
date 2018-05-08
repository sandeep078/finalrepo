
resource "aws_iam_server_certificate" "test_cert" {
  name             = "some_test_cert"
  certificate_body = "${file("server.cert")}"
  private_key      = "${file("server.key")}"
}

resource "aws_elb" "wp_elb" {
  name = "newbalancer-elb"

  subnets = ["${aws_subnet.wp_public1_subnet.id}",
    "${aws_subnet.wp_public2_subnet.id}",
  ]

  security_groups = ["${aws_security_group.wp_sg.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 8080
    lb_protocol       = "tcp"
  }
 listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.test_cert.arn}"
  }



  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

 # instances = ["${aws_instance.webserver.id}",
 #   "${aws_instance.appserver.id}",
 # ]

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "wp_elb_new"
  }
}
