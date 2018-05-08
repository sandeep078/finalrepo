# ----- Golden ami ----


# ami

resource "aws_ami_from_instance" "wp_golden" {
  name               = "wp_ami_tomcat"
  source_instance_id = "${aws_instance.webserver.id}"
}
