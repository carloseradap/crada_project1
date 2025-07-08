# 🛠️ AKS + Terraform + GitHub + RBAC Troubleshooting Guide

This guide documents real-world issues encountered while provisioning and accessing an Azure Kubernetes Service (AKS) cluster using Terraform, GitHub, and Azure AD. It includes solutions for Git errors, secret scanning blocks, RBAC misconfigurations, and cross-platform kubeconfig issues.

---

## 📌 Context

- AKS provisioned via Terraform
- GitHub used for version control
- Azure AD used for identity and access management
- WSL (Linux) used for CLI, with kubeconfig written to Windows

---

## 1. ❌ Terraform Apply Fails: `ServiceCidrOverlapExistingSubnetsCidr`

**Error:**


The specified service CIDR 10.0.0.0/16 is conflicted with an existing subnet CIDR 10.0.1.0/24.

**Solution:**
Update the `network_profile` block in Terraform:

```hcl
network_profile {
  service_cidr       = "10.1.0.0/16"
  dns_service_ip     = "10.1.0.10"
  docker_bridge_cidr = "172.17.0.1/16"
}



2. ❌ Terraform Apply Fails After Manual Deletion
Error:
Failed to get a VNet: devops-vnet


Solution:
- Run terraform refresh, or
- Delete .terraform/, terraform.tfstate, and re-run terraform init

3. ❌ Git Push Fails: Large Files Detected
Error:
File exceeds GitHub's file size limit of 100.00 MB


Solution:
- Add to .gitignore:
.terraform/
*.tfstate
*.tfstate.*
- Remove from Git history:
git filter-repo --path infra/.terraform --invert-paths --force
- Force push:
git push origin main --force



4. ❌ GitHub Push Blocked: Secret Detected in terraform.tfstate
Error:
Push cannot contain secrets — Azure Registry Key Identifiable


Solution:
- Remove from history:
git filter-repo --path infra/terraform.tfstate --invert-paths --force
- Add to .gitignore:
*.tfstate
*.tfstate.*
- Force push again

5. ❌ kubectl debug Fails: Authentication Required
Error:
Authentication required — HTML login redirect


Solution:
az aks get-credentials --admin --resource-group devops-rg --name devops-aks


If using WSL:
export KUBECONFIG=/mnt/c/Users/admin/.kube/config



6. ❌ Azure AD User Has No Subscription Access
Error:
No subscriptions found for devopsadmin@...


Solution: Assign the user a role:
az role assignment create \
  --assignee devopsadmin@cradatestgmail.onmicrosoft.com \
  --role "Owner" \
  --scope /subscriptions/<your-subscription-id>



7. ❌ Azure AD User Can't Access AKS (403 Forbidden)
Error:
Authentication required — HTML login redirect


Solution: Create a ClusterRoleBinding:
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: devopsadmin-cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: User
  name: "devopsadmin@cradatestgmail.onmicrosoft.com"
  apiGroup: rbac.authorization.k8s.io


Apply it:
kubectl apply -f devopsadmin-binding.yaml



8. ❌ kubectl Shows current-context is not set
Cause: Kubeconfig written to Windows path, but WSL kubectl looks in Linux path.
Solution:
export KUBECONFIG=/mnt/c/Users/admin/.kube/config


To persist:
echo 'export KUBECONFIG=/mnt/c/Users/admin/.kube/config' >> ~/.bashrc
source ~/.bashrc



✅ Final Outcome
- Clean GitHub repo with no secrets or large files
- AKS cluster deployed and accessible
- Azure AD user (devopsadmin) with full Kubernetes access
- Cross-platform kubeconfig working in WS

🧠 Pro Tip
Use this guide as a reference when:
- Setting up new AKS clusters
- Managing GitHub Terraform repos
- Troubleshooting Azure RBAC and Kubernetes access

Authored by Carlos Rada — DevOps in the making 
