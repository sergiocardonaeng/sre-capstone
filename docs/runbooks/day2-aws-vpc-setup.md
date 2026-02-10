\# Day 2 — AWS VPC Setup (Terraform)



\## Goal

Create a real AWS networking baseline (low-cost) using Terraform: a VPC with one public subnet and one private subnet, plus routing via an Internet Gateway.



\## What we built

\- 1 VPC (CIDR: 10.10.0.0/16)

\- 1 Internet Gateway (IGW) attached to the VPC

\- 1 Public subnet (CIDR: 10.10.1.0/24) in a single AZ

\- 1 Private subnet (CIDR: 10.10.2.0/24) in the same AZ

\- Public route table with a default route (0.0.0.0/0) to the IGW

\- Route table associations:

&nbsp; - Public subnet -> public route table

&nbsp; - Private subnet -> private route table



\## Why this matters (concepts)

\- A \*\*public subnet\*\* is “public” because its route table has a path to the Internet Gateway (0.0.0.0/0 -> IGW).

\- A \*\*private subnet\*\* has no direct route to the IGW. Without a NAT Gateway (not used today), instances in the private subnet cannot reach the public internet.



\## Commands used (and what they do)

\- `terraform init` — downloads the AWS provider and initializes the working directory.

\- `terraform fmt -recursive` — formats Terraform code across the project for consistency.

\- `terraform validate` — checks Terraform syntax and configuration for errors.

\- `terraform plan` — shows what Terraform will create/change without applying it.

\- `terraform apply` — creates the resources in AWS.

\- `terraform destroy` — deletes the resources created by Terraform (used when cleaning up).



\## How to verify

\### Terraform outputs

After `terraform apply`, Terraform prints outputs such as:

\- `vpc\_id`

\- `public\_subnet\_id`

\- `private\_subnet\_id`



\### AWS Console checks

In the AWS VPC console:

\- Confirm the VPC exists with the expected CIDR

\- Confirm subnets exist with correct CIDRs and AZ

\- Confirm the public route table has:

&nbsp; - `0.0.0.0/0 -> Internet Gateway`



\## Next steps

\- Add a Security Group and an EC2 instance to reproduce a “why can’t I connect” scenario.

\- Document a troubleshooting checklist for SG/CIDR/ports + routing validation.



