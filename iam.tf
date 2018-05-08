#-----IAM----

resource "aws_iam_user" "newuser" {
  name = "sandeep"
}

resource "aws_iam_access_key" "newkey" {
  user = "${aws_iam_user.newuser.name}"
}

resource "aws_iam_user_policy" "newpolicy" {
  name = "test"
  user = "${aws_iam_user.newuser.name}"

policy = <<EOF
{

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
  }
EOF

}
