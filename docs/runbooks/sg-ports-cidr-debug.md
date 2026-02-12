# Runbook — “Why can’t I connect?” (AWS SG / CIDR / Ports)

## Scenario
SSH to an EC2 instance times out.

## Environment
- VPC: vpc-08f2b88041b5d9145
- Public subnet: subnet-01ba7a517bedbe148

## Symptoms
- `ssh -i <key.pem> ec2-user@<public_ip>` results in a timeout.

## Fast checks (first 5 minutes)
1) Confirm the instance has a public IP.
2) Confirm the subnet is public:
   - Route table contains `0.0.0.0/0 -> Internet Gateway`
3) Confirm the Security Group inbound allows:
   - TCP/22 from your current public IP (`<your_ip>/32`)

## Commands used
- `terraform output ec2_public_ip` — get the instance public IP.
- `curl ifconfig.me` (or PowerShell `Invoke-WebRequest`) — get your current public IP.
- `ssh -i <key.pem> ec2-user@<public_ip>` — attempt SSH.

## Root cause (example)
Inbound SG rule used an incorrect CIDR block, so SSH from my public IP was blocked.

## Fix
Update the inbound SG rule to allow `TCP/22` from `<your_public_ip>/32`, then `terraform apply`.

## Notes
If SG is correct but access still fails, check NACLs, route tables, and the instance OS firewall.
