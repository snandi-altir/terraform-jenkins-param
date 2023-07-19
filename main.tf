resource "aws_instance" "foo" {
  ami           = var.amid # us-west-2
  instance_type = var.instance_size
  tags          = local.tags
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucketname
  acl    = var.acl_type

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
