# kube-everything

这个项目主要是为了用一个镜像把平时在做 k8s 开发过程中需要用到的软件和 alias 一次性配置完，这样不管我怎么切换环境，只要有 Docker 就能用起来。

## 安装的软件

细节都在 [Dockerfile](Dockerfile) 了，可以仔细看看，如果想加什么的，也可以随便加。

## Docker Hub镜像

```shell
docker pull runzhliu/kube-everything:latest
# 挂载主机的/root/.kube目录
cp ~/.kube/config /tmp/config && docker run -v /tmp/config:/root/.kube/config --net=host -it runzhliu/kube-everything:latest
# 进入容器后查看help
cat help
# 如果CRI是containerd，就使用nerdctl
cp ~/.kube/config /tmp/config && nerdctl run -v /tmp/config:/root/.kube/config --net=host -it runzhliu/kube-everything:latest
```

## Docker使用

```shell
➜  kube-everything git:(main) cp ~/.kube/config /tmp/config && docker run -v /tmp/config:/root/.kube/config --net=host -it runzhliu/kube-everything:latest
➜  /kube-everything kc
kubeovn
macvlan
stable-cluster
➜  /kube-everything kn
cmdb
default
harbor
kube-node-lease
kube-public
kube-system
longhorn-system
minio-cluster
outer-prometheus
security-scan
thanos
➜  /kube-everything k get po
NAME                                    READY   STATUS    RESTARTS   AGE
kibana-7b8c4c885-4fmmn                  1/1     Running   0          69d
oa-metting-deployment-5df9d79c9-thp5t   1/1     Running   0          40d
squida-67dd794859-p4l8b                 1/1     Running   1          45d
yum-with-browser                        2/2     Running   0          6d22h
➜  /kube-everything helm ls
NAME	NAMESPACE	REVISION	UPDATED                               	STATUS  	CHART           	APP VERSION
elk 	default  	2       	2022-03-03 11:34:33.684772 +0800 +0800	deployed	elk-7.6.2
loki	default  	1       	2022-01-27 11:37:57.209311 +0800 +0800	deployed	loki-stack-2.1.2	v2.0.0
```

## Kubernetes部署

kube-everything 可以在 Kubernetes 集群部署，可以以 Pod 或者 Deployment 或其他方式进行部署，具体可以参考 [deploy.yaml](./k8s/deploy.yaml)。

## 重新编译镜像

可以修改 [Makefile](Makefile) 然后执行 `make`。

## TODO

- [x] 常用的kubectl插件
- [ ] 网络排查工具和脚本
- [ ] 提供参数更新工具版本
- [x] 安装helm
- [ ] 解决zshrc读取的问题
