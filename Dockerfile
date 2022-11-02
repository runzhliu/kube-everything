FROM centos:7

WORKDIR /kube-everything

# 换yum源
RUN rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

# 安装zsh和oh-my-zsh
RUN yum install -y zsh git vim unzip tree lrzsz bash-completion wget
# RUN curl -Lo zsh.zip https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip && unzip zsh.zip && mv ohmyzsh-master/ ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

COPY zsh-in-centos.sh .
RUN /kube-everything/zsh-in-centos.sh \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search' \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

# 安装kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/

# 安装kubectx和kubens
RUN curl -Lo kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx_v0.9.4_linux_x86_64.tar.gz && tar -zxvf kubectx.tar.gz -C /usr/bin/
RUN curl -Lo kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubens_v0.9.4_linux_x86_64.tar.gz && tar -zxvf kubens.tar.gz -C /usr/bin/

# 安装kubecm
RUN curl -Lo kubecm.tar.gz https://github.com/sunny0826/kubecm/releases/download/v0.17.0/kubecm_0.17.0_Linux_x86_64.tar.gz && tar -zxvf kubecm.tar.gz -C /usr/bin/

# 安装helm
RUN curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz && tar -zxvf helm.tar.gz -C /usr/bin && mv /usr/bin/linux-amd64/helm /usr/bin/

# 安装krew
RUN set -x && OS="$(uname | tr '[:upper:]' '[:lower:]')" && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && KREW="krew-${OS}_${ARCH}" && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && tar zxvf "${KREW}.tar.gz" && ./"${KREW}" install krew iexec example doctor df-pv resource-capacity view-allocations tail

# 安装calicoctl插件
RUN curl -L https://github.com/projectcalico/calico/releases/download/v3.23.1/calicoctl-linux-amd64 -o kubectl-calico && chmod +x kubectl-calico && mv kubectl-calico /usr/local/bin/

# 安装k9s
RUN curl -Lo k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz && tar -zxvf k9s.tar.gz -C /usr/bin

# 安装kube-ps1
RUN git clone https://github.com/jonmosco/kube-ps1.git /usr/local/kube-ps1

# 安装bat
RUN curl -Lo bat-0.7.0-1.of.el7.x86_64.rpm http://repo.openfusion.net/centos7-x86_64/bat-0.7.0-1.of.el7.x86_64.rpm && yum install -y bat-0.7.0-1.of.el7.x86_64.rpm

# 安装fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# 缩小一点镜像大小
RUN rm -rf /kube-everything/* /tmp/* && yum clean all

# 自定义的alias
RUN echo -e 'alias kc=kubectx \nalias kn=kubens \nalias k=kubectl \nalias kcm=kubecm \nalias ke="k exec -it" \nalias kie="k iexec" \nexport LC_CTYPE=en_US.UTF-8 \nexport PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"\nsource <(kubectl completion zsh)' >> ~/.zshrc

ADD help .

# start zsh
ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]
