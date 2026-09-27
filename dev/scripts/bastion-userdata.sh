#!/bin/bash
set -euxo pipefail

# ============================================================
# EKS 1.36 Tool Versions
# ============================================================
KUBECTL_VERSION="1.36.2"
EKSCTL_VERSION="0.215.0"
HELM_VERSION="v3.21.4"


# ============================================================
# 1. Package
# AWS CLI / curl : AL2023 기본 설치 사용
# ============================================================
dnf install -y \
  git \
  jq \
  unzip \
  bash-completion \
  docker


# ============================================================
# 2. steve User
# ============================================================
if ! id steve &>/dev/null; then
  useradd -m -s /bin/bash steve
fi

# sudo / docker 권한
usermod -aG wheel steve
usermod -aG docker steve


# ============================================================
# 3. SSH Password Authentication
# 비밀번호 자체는 User Data에 저장하지 않음
# ============================================================
cat > /etc/ssh/sshd_config.d/99-steve-password.conf <<'EOF'
PasswordAuthentication yes
EOF

sshd -t
systemctl restart sshd


# ============================================================
# 4. Docker
# ============================================================
systemctl enable --now docker


# ============================================================
# 5. kubectl - EKS 1.36
# ============================================================
curl -o /usr/local/bin/kubectl \
  "https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2026-07-05/bin/linux/amd64/kubectl"

chmod 0755 /usr/local/bin/kubectl


# ============================================================
# 6. eksctl
# ============================================================
cd /tmp

curl -sLO \
  "https://github.com/eksctl-io/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz"

tar -xzf eksctl_Linux_amd64.tar.gz

install -m 0755 eksctl /usr/local/bin/eksctl

rm -f eksctl eksctl_Linux_amd64.tar.gz


# ============================================================
# 7. Helm
# ============================================================
curl -sLO \
  "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"

tar -xzf "helm-${HELM_VERSION}-linux-amd64.tar.gz"

install -m 0755 linux-amd64/helm /usr/local/bin/helm

rm -rf linux-amd64 "helm-${HELM_VERSION}-linux-amd64.tar.gz"


# ============================================================
# 8. Bash Completion
# kubectl + k + eksctl + helm
# ============================================================
cat <<'EOF' >> /home/steve/.bashrc

# kubectl
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

# eksctl
source <(eksctl completion bash)

# helm
source <(helm completion bash)

EOF

chown steve:steve /home/steve/.bashrc


# ============================================================
# 9. Verification
# ============================================================
{
  echo "===== Bastion Setup Complete ====="

  aws --version
  curl --version
  kubectl version --client
  eksctl version
  helm version --short
  docker --version
  git --version

  echo "===== SSH Password Authentication ====="
  sshd -T | grep -i passwordauthentication

} > /var/log/bastion-install.log 2>&1
