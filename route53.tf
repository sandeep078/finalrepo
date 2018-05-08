#----Route 53-----

#Primary zone

resource "aws_route53_zone" "primary" {
  name              = "www.sandeep078.tk"
#  delegation_set_id = "N2K2HS019U9HV1"
}

#www

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.sandeep078.tk"
  type    = "A"
  alias {
    name                   = "${aws_elb.wp_elb.dns_name}"
    zone_id                = "${aws_elb.wp_elb.zone_id}"
    evaluate_target_health = false
  }
}

#dev

# resource "aws_route53_record" "dev" {
#  zone_id = "${aws_route53_zone.primary.zone_id}"
#  name    = "dev.sandeep078.tk"
#  type    = "A"
#  ttl     = "300"
#  records = ["${aws_instance.webserver.public_ip}"]
# }

#private zone

resource "aws_route53_zone" "secondary" {
  name   = "www.sandeep078.tk"
  vpc_id = "${aws_vpc.wp_vpc.id}"
}
