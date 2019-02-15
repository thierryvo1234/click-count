# S3

Edit s3.tf:
```console
resource "aws_s3_bucket" "example-bucket" {
  bucket = "terraform-getting-started-guide"
  acl = "private"
}


```
