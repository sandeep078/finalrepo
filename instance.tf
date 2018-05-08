resource "aws_instance" "webserver" {
  ami             =  "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.mykey.key_name}"
  vpc_security_group_ids = ["${aws_security_group.wp_sg.id}"]
  subnet_id       = "${aws_subnet.wp_public1_subnet.id}"


 provisioner "local-exec" {
     command = "sleep 30 && echo \"[tomcat-servers]\n${aws_instance.webserver.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > tomcat-inventory &&  ansible-playbook -i tomcat-inventory ansible-playbooks/tomcat-site.yml "
  }
 connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
 tags {
     Name = "webserver"
   }


}



resource "aws_elb_attachment" "baz" {
  elb      = "${aws_elb.wp_elb.id}"
  instance = "${aws_instance.webserver.id}"
}


resource "aws_instance" "jenkins" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.wp_sg.id}" ]
  key_name = "${aws_key_pair.mykey.key_name}"
#  iam_instance_profile = "${aws_iam_role.test_role.name}"
  subnet_id       = "${aws_subnet.wp_public1_subnet.id}"

   provisioner "local-exec" {
     command = "sleep 30 && echo \"[jenkins-server]\n${aws_instance.jenkins.public_ip} ansible_connection=ssh ansible_ssh_user=ec2-user ansible_ssh_private_key_file=mykey host_key_checking=False\" > jenkins-inventory &&  ansible-playbook -i jenkins-inventory ansible-playbooks/jenkins-create.yml "
  }

  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
 tags {
     Name = "jenkins"
   }

}


resource "aws_instance" "bastion" {
  ami             = "ami-43a15f3e"
  instance_type   = "t2.micro"
  key_name        =  "${aws_key_pair.mykey.key_name}"
  vpc_security_group_ids = ["${aws_security_group.wp_sg.id}"]
  subnet_id       = "${aws_subnet.wp_public1_subnet.id}"

  tags {
    Name = "bastion"
  }
}
