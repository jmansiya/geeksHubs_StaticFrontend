resource "aws_s3_bucket" "bucket" {
  bucket = var.bucketname

  provisioner "local-exec" {
    command = "sleep 20"
    interpreter = ["/bin/bash", "-c"]
  }
  tags = {
    Name        = var.bucketname
    Project     = var.project
    Creator     = var.creator
    Environment = var.environment
    Terraform   = var.terraform
  }
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}