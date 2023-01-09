provider "aws" {
    region = "us-east-1"
    version = "~> 2.46"
}

resource "aws_iam_user" "tf-user1234" {

    count = 2
    name = "tf-user_123_${count.index}"

}