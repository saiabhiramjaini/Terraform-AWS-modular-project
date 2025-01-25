provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"

  ami_value         = var.ami_value
  instance_type_value = var.instance_type_value
  subnet_id_value   = var.subnet_id_value
  key_name_value    = var.key_name_value
}

module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name_value = var.bucket_name_value
}