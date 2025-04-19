# Terraform AWS

> **Objective**: Automatically provision a basic AWS environment that includes:
> * VPC with Public & Private subnets
> * Internet Gateway and NAT Gateway
> * Route Tables (public + private)
> * Security Groups (for the Public and Private EC2 instances)
> * Two EC2 instances (one in the public subnet, one in the private subnet)
>
> All resources are defined through **re‑usable Terraform modules** for maximum flexibility.

---

## 1. Architecture overview

```text
┌──────────────────────────── AWS Account ──────────────────────────────┐
│                                                                       │
│  VPC (10.0.0.0/16)                                                    │
│  ├─ Internet Gateway ───────────────────────────────────────────────┐ │
│  │                                                                  ▲ │
│  ├─► Public Subnet (10.0.1.0/24)                                    │ │
│  │    • EC2‑Public (t2.micro) [Elastic IP]                          │ │
│  │    • NAT Gateway [EIP]                                           │ │
│  │           ▲      │                                               │ │
│  │           │      └─ Route Table (0.0.0.0/0 → IGW) ───────────────┘ │
│  │           │                                                        │
│  │           └────────────────────────────────────────────────────┐   │
│  └─► Private Subnet (10.0.2.0/24)                                 │   │
│        • EC2‑Private (t2.micro)                                   │   │
│                                                                   │   │
│           Route Table (0.0.0.0/0 → NAT Gateway) ──────────────────┘   │
└───────────────────────────────────────────────────────────────────────┘
```

* **Public EC2** — Has a public IP; you can SSH into it directly from your workstation.
* **Private EC2** — No public IP; reachable only through the Public EC2 (bastion) or AWS SSM.
* **NAT Gateway** — Lets hosts in the private subnet reach the Internet (OS updates, package downloads, etc.).

---

## 2. Prerequisites

| Requirement | Details |
|-------------|---------|
| **Terraform** | ≥ 1.0.0 (tested with 1.6.x) |
| **AWS CLI**   | ≥ 2.x and configured with `aws configure` |
| **AWS IAM**   | At least *AdministratorAccess* for the demo **or** a set of least‑privilege policies that cover the resources below. |
| **Key Pair**  | Pre‑created in the EC2 Console (e.g. `my-keypair`). |
| **Client IP** | Your static IPv4 address in CIDR form (e.g. `203.0.113.10/32`) **or** `0.0.0.0/0` if you do not want to set a specific IP, to allow inbound SSH. |
| **Git**       | To clone the repository. |

> **Note:** The demo deploys to **`us-east-1`** by default; adjust region/AZs as needed.

---

## 3. Directory layout

```text
.
├── main.tf              # Calls modules & optionally configures backend
├── variables.tf         # Root‑level variables
├── outputs.tf           # Root‑level outputs
├── terraform.tfvars     # (git‑ignored) — real‑world variable values
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security_groups/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md            # You are here
```

### When should I split extra modules?
* If you need to reuse or deeply customise components such as the **NAT Gateway**, **Elastic IP**, or **Route Tables**.
* Whenever a public module from the [Terraform Registry](https://registry.terraform.io/) already fits your requirements — prefer reuse over rewrite.

---

## 4. Input variables (root module)

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | `"us-east-1"` | AWS region |
| `project_name` | string | `"devops-lab01"` | Tag prefix for all resources |
| `vpc_cidr` | string | `"10.0.0.0/16"` | VPC CIDR range |
| `public_subnets` | list(string) | `["10.0.1.0/24"]` | One CIDR block per AZ for public subnets |
| `private_subnets` | list(string) | `["10.0.2.0/24"]` | One CIDR block per AZ for private subnets |
| `azs` | list(string) | `["us-east-1a"]` | Availability Zones corresponding to the subnets |
| `my_ip` | string | **required** | IPv4/32 allowed to SSH into the bastion |
| `ami_id` | string | **required** | AMI ID for EC2 instances (e.g. Amazon Linux 2) |
| `instance_type` | string | `"t2.micro"` | EC2 instance type |
| `key_name` | string | **required** | The name of the EC2 Key Pair |

`terraform.tfvars` is the recommended place to set real values:

```hcl
project_name    = "devops-lab01"
my_ip           = "203.0.113.10/32"
key_name        = "my-keypair"
ami_id          = "ami-01f5a0b78d6089704" # AmazonLinux2 in us-east-1
public_subnets  = ["10.0.1.0/24"]
private_subnets = ["10.0.2.0/24"]
azs             = ["us-east-1a"]
```

---

## 5. Usage

### 5.1. Clone the repository
```bash
git clone https://github.com/Cazo04/devops-lab01-aws-terraform.git
cd devops-lab01-aws-terraform
```

### 5.2. Initialize Terraform
```bash
terraform init
```
* Downloads the **hashicorp/aws** provider.
* Creates the `.terraform` directory.
* (Optional) Configures a **remote backend** (S3 + DynamoDB) for shared state.

### 5.3. Validate & format
```bash
terraform validate          # static checks
terraform fmt -recursive    # ensure canonical style
```

### 5.4. Plan
```bash
terraform plan -out=plan.out
```
*Review the execution plan — including the estimated cost.*

### 5.5. Apply
```bash
terraform apply "plan.out"
```
* Confirm with `yes`.
* Provisioning usually finishes in ~3–4 minutes.

### 5.6. Verification steps
1. Open the AWS Console → **VPC** and verify all subnets, route tables, gateways.
2. Go to **EC2** and note the **Public IP** of the bastion.
3. SSH from your workstation:
   ```bash
   ssh -i ~/.ssh/my-keypair.pem ec2-user@<public_ec2_public_ip>
   ```
4. From the bastion, SSH into the private instance:
   ```bash
   ssh -i ~/.ssh/my-keypair.pem ec2-user@<private_ec2_private_ip>
   ```
5. On the private instance, run `curl https://api.ipify.org` — you should get the NAT GW EIP.

### 5.7. Destroy
```bash
terraform destroy
```
> **Important:** NAT Gateways incur an hourly charge plus data transfer; destroy your stack when you no longer need it.

---

## 6. Suggested test cases

| # | Check | Expected result |
|---|-------|----------------|
| TC‑01 | Public EC2 can `ping`/`curl` the Internet | Pass (via IGW) |
| TC‑02 | Private EC2 can `curl` the Internet | Pass (via NAT GW) |
| TC‑03 | Direct SSH from the Internet to Private EC2 | Fail (blocked) |
| TC‑04 | SSH from Public EC2 → Private EC2 | Pass |

---

## 7. CI/CD ideas

* **GitHub Actions**
  * Workflow: `init → validate → plan → manual approval → apply` using the `hashicorp/setup-terraform` action.
  * Store the **TF state** in an S3 backend and lock via DynamoDB.
* **Jenkins**
  * Docker‑based agent with Terraform CLI.
  * Stages: *lint* → *plan* → *approval* → *apply*.

Refer to `.github/workflows/terraform.yml` for a sample implementation.

---

## 8. Security & best practices

1. **Least‑privilege IAM** — create a dedicated *Terraform user* with only the permissions required.
2. **Secure state** — enable S3 server‑side encryption (SSE‑AES256) and block public access.
3. **Secrets handling** — use GitHub Secrets/Jenkins Credentials instead of committing them.
4. **Key Pair hygiene** — protect your `.pem` file (`chmod 400`).
5. **Ingress rules** — restrict `my_ip`; consider dynamic blocks if multiple offices/users need SSH access.

---

## 9. Cost estimation (us‑east‑1 | 730 h/month)

| Service | Qty | Unit price | Monthly cost ≈ |
|---------|-----|------------|----------------|
| **t2.micro** | 2 | 0.0116 $/h |  17 $ |
| **NAT GW** | 1 | 0.045 $/h + 0.045 $/GB |  32 $ (excl. traffic) |
| **EIP** | 2 | 0 $ (attached) / 0.005 $/h (idle) |  0 $ |
| **S3 state** | ~1 GB | 0.03 $ |  ≈ 0 $ |
| **Total** |   |   | **≈ 50 $** |

Delete or stop resources (especially the NAT GW) when idle.

---

## 10. Common troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `timeout while waiting for state to become available` | NAT GW creation is slow | Increase timeouts or simply wait longer |
| Cannot SSH into EC2 | Wrong SG or key | Check `my_ip`, `key_name`, correct user (`ec2-user` / `ubuntu`), `chmod 400` on key |
| Private EC2 has no Internet | Route table not associated / NAT GW issue | `aws ec2 describe-route-tables` or `terraform taint` the NAT GW to recreate |

---

## 11. Next steps

* Add an **Auto Scaling Group** and an **Application Load Balancer**.
* Replace SSH with **SSM Session Manager**.
* Implement **CloudWatch Logs/Alarms** and **AWS Config** for governance.
* Deploy a **RDS/Aurora** cluster in the private subnet.

---

## 12. Contributing

1. Fork the repo and create a feature/bugfix branch.
2. Run `terraform fmt -recursive` before committing.
3. Open a Pull Request with a screenshot of the `terraform plan` output.

---

## 13. License

This project is licensed under the **MIT License** — see `LICENSE` for details.

---

**© 2025 Nguyen Hoang Khang / NT548.P21**

