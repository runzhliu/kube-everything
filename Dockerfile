FROM centos:7

WORKDIR /kube-everything

# 换yum源
RUN rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

# 安装zsh和oh-my-zsh
RUN yum install -y zsh git vim unzip
RUN curl -Lo zsh.zip https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip && unzip zsh.zip && mv ohmyzsh-master/ ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# 安装kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/

# 安装kubectx和kubens
RUN curl -Lo kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubectx_v0.9.4_linux_x86_64.tar.gz && tar -zxvf kubectx.tar.gz -C /usr/bin/
RUN curl -Lo kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.4/kubens_v0.9.4_linux_x86_64.tar.gz && tar -zxvf kubens.tar.gz -C /usr/bin/

# 安装kubecm
RUN curl -Lo kubecm.tar.gz https://github.com/sunny0826/kubecm/releases/download/v0.17.0/kubecm_0.17.0_Linux_x86_64.tar.gz && tar -zxvf kubecm.tar.gz -C /usr/bin/

# 安装helm
RUN curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz && tar -zxvf helm.tar.gz -C /usr/bin && mv /usr/bin/linux-amd64/helm /usr/bin/

# 开启kubectl自动补全
# RUN source <(kubectl completion zsh)

# 缩小一点镜像大小
RUN rm -rf /kube-everything/* && yum clean all

# 自定义的alias
RUN echo -e 'alias kc=kubectx \n alias kn=kubens \n alias k=kubectl \n alias kcm=kubecm \n alias ke="k exec -it" \ PROMPT_COMMAND="history -a" ' >> ~/.zshrc

# start zsh
CMD [ "zsh" ]
