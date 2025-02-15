## Terraform Modular Approach 

###  What is the Modular Approach in Terraform?
A **modular approach** in Terraform refers to breaking down infrastructure into **reusable, independent, and self-contained modules**. Instead of defining all resources in a single file, modules allow you to organize and reuse configurations for better **scalability**, **maintainability**, and **reusability**.



### Example Modular Project Structure
```
saiabhiramjaini-terraform-aws-modular-project/
│── main.tf                   # Root module - calls other modules (EC2, S3)
│── variables.tf               # Global variables for the root module
│── modules/                   # Directory for reusable Terraform modules
│   ├── ec2_instance/          # EC2 module (Reusable)
│   │   ├── main.tf            # Defines EC2 instance resource
│   │   ├── outputs.tf         # Outputs (e.g., Public IP, Instance ID)
│   │   ├── variables.tf       # Input variables (e.g., AMI ID, Instance type)
│   ├── s3_bucket/             # S3 bucket module (Reusable)
│   │   ├── main.tf            # Defines S3 bucket resource
│   │   ├── outputs.tf         # Outputs (e.g., Bucket ARN, Name)
│   │   ├── variables.tf       # Input variables (e.g., Bucket name)
```

---

###  Root `main.tf` (Calls Modules)

The root module **calls other modules** (`ec2_instance`, `s3_bucket`) by specifying their source and passing required variables.

#### Root `main.tf`
```hcl
provider "aws" {
  region = "ap-south-1"
}

module "ec2_instance" {
  source        = "./modules/ec2_instance"   # Path to the EC2 module
  instance_type = "t2.micro"
  ami_id        = "ami-0abcdef1234567890"
}

module "s3_bucket" {
  source      = "./modules/s3_bucket"   # Path to the S3 module
  bucket_name = "my-terraform-bucket"
}
```
**What Happens Here?**
- Terraform **calls the EC2 module** and provides `instance_type` and `ami_id`.
- Terraform **calls the S3 module** and provides the `bucket_name`.


###   EC2 Module (`modules/ec2_instance/`)
This module creates an **AWS EC2 instance**.

#### `modules/ec2_instance/main.tf`
```hcl
resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Terraform-EC2"
  }
}
```

#### `modules/ec2_instance/variables.tf`
Defines input variables required for EC2.

```hcl
variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2"
}
```

#### `modules/ec2_instance/outputs.tf`
Exports EC2 instance details.

```hcl
output "instance_id" {
  value = aws_instance.ec2.id
}
```



### Deploying the Terraform Code
#### 1. Initialize Terraform
```sh
terraform init
```
This downloads the required provider plugins and initializes the project.

#### 2. Plan the Infrastructure
```sh
terraform plan
```
This shows what resources will be created without applying them.

#### 3. Apply the Configuration
```sh
terraform apply -auto-approve
```
This creates the **EC2 instance** and **S3 bucket** using modular Terraform.

#### 4. Destroy the Infrastructure (Optional)
```sh
terraform destroy -auto-approve
```
This removes all created AWS resources.


### Why Use Modular Terraform?
| Advantage | Description |
|-----------|-------------|
| **Reusability** | The same EC2/S3 module can be used in multiple projects. |
| **Maintainability** | Easier to update and manage infrastructure components. |
| **Scalability** | Easily add new modules like RDS, VPC, IAM without modifying the root `main.tf`. |
| **Flexibility** | Different environments (`dev`, `staging`, `prod`) can use the same modules with different values. |

