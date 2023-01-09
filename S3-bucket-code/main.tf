provider "aws" {
    region = "us-east-1"
    version = "~> 2.46"
}

resource "aws_s3_bucket" "sk_bucket" {
    bucket = "sk-bucket-1233"
    versioning  {
        enabled = true
     
    }
}

output "sk_bucket_versioning" {
    value = aws_s3_bucket.sk_bucket.versioning[0].enabled

}