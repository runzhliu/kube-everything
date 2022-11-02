#!/usr/bin/env sh

rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

yum install -y zsh git vim unzip tree

curl -Lo zsh.zip https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip && unzip zsh.zip && mv ohmyzsh-master/ ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# 安装kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/

# 安装kubectx和kubens
curl -Lo kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx_v0.9.4_linux_x86_64.tar.gz && tar -zxvf kubectx.tar.gz -C /usr/bin/
curl -Lo kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubens_v0.9.4_linux_x86_64.tar.gz && tar -zxvf kubens.tar.gz -C /usr/bin/

# 安装kubecm
curl -Lo kubecm.tar.gz https://github.com/sunny0826/kubecm/releases/download/v0.17.0/kubecm_0.17.0_Linux_x86_64.tar.gz && tar -zxvf kubecm.tar.gz -C /usr/bin/

# 安装helm
curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz && tar -zxvf helm.tar.gz -C /usr/bin && mv /usr/bin/linux-amd64/helm /usr/bin/

# 安装k9s
curl -Lo k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz && tar -zxvf k9s.tar.gz -C /usr/bin

# 安装krew
set -x && OS="$(uname | tr '[:upper:]' '[:lower:]')" && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && KREW="krew-${OS}_${ARCH}" && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && tar zxvf "${KREW}.tar.gz" && ./"${KREW}" install krew iexec example doctor df-pv resource-capacity view-allocations tail

# 安装kube-ps1
git clone https://github.com/jonmosco/kube-ps1.git /usr/local/kube-ps1

# 开启kubectl自动补全
source <(kubectl completion zsh)

# 自定义的alias
echo -e 'alias kc=kubectx \nalias kn=kubens \nalias k=kubectl \nalias kcm=kubecm \nalias ke="k exec -it" \nalias kie="k iexec" \nexport LC_CTYPE=en_US.UTF-8 \nexport PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc