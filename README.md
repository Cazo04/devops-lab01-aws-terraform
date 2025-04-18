# Terraform AWS Project

This project is designed to provision AWS infrastructure using Terraform. It includes configurations for a Virtual Private Cloud (VPC), EC2 instances, and security groups, organized into modules for better management and reusability.

## Project Structure

```
terraform-aws-project
├── main.tf               # Main configuration file for the Terraform project
├── variables.tf          # Input variables for the Terraform configuration
├── outputs.tf            # Output values after Terraform apply
└── modules               # Contains reusable modules
    ├── vpc               # Module for VPC setup
    │   ├── main.tf       # VPC resources configuration
    │   ├── variables.tf   # Input variables for VPC module
    │   └── outputs.tf     # Output values for VPC module
    ├── ec2               # Module for EC2 instances
    │   ├── main.tf       # EC2 resources configuration
    │   ├── variables.tf   # Input variables for EC2 module
    │   └── outputs.tf     # Output values for EC2 module
    └── security_groups    # Module for security groups
        ├── main.tf       # Security groups resources configuration
        ├── variables.tf   # Input variables for security groups module
        └── outputs.tf     # Output values for security groups module
```

## Getting Started

1. **Prerequisites**
   - Ensure you have [Terraform](https://www.terraform.io/downloads.html) installed.
   - Configure your AWS credentials.

2. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd terraform-aws-project
   ```

3. **Initialize Terraform**
   Run the following command to initialize the Terraform configuration:
   ```bash
   terraform init
   ```

4. **Plan the Infrastructure**
   To see what resources will be created, run:
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**
   To create the resources defined in the configuration, run:
   ```bash
   terraform apply
   ```

6. **Outputs**
   After applying the configuration, you can view the output values defined in `outputs.tf`.

## Modules

- **VPC Module**: Customize your VPC settings in `modules/vpc/variables.tf`.
- **EC2 Module**: Customize your EC2 instance settings in `modules/ec2/variables.tf`.
- **Security Groups Module**: Customize your security group settings in `modules/security_groups/variables.tf`.

## Cleanup

To destroy the resources created by Terraform, run:
```bash
terraform destroy
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.