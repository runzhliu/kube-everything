# kube-everything

这个项目主要是为了用一个镜像把平时在做 k8s 开发过程中需要用到的软件和 alias 一次性配置完，这样不管我怎么切换环境，只要有 Docker 就能用起来。

## 安装的软件

细节都在 [Dockerfile](Dockerfile) 了，可以仔细看看，如果想加什么的，也可以随便加。

## Docker Hub镜像

```shell
docker pull runzhliu/kube-everything:latest
# 挂载主机的/root/.kube目录
cp ~/.kube/config /tmp/config && docker run -v /tmp/config:/root/.kube --net=host -it runzhliu/kube-everything:latest
# 绑定主机的bash_history，方便搜命令
cp ~/.kube/config /tmp/config && docker run -v /tmp/config:/root/.kube -v /root/.bash_history:/root/.bash_history --net=host -it runzhliu/kube-everything:latest
```

## 使用

```shell
➜  kube-everything git:(main) cp ~/.kube/config /tmp/config && docker run -v /tmp/config:/root/.kube/config --net=host -it runzhliu/kube-everything:latest
➜  /kube-everything kc
k8s-yunying
kubeovn
macvlan
stable-cluster
stable-local
stable-test
➜  /kube-everything kn
cattle-prometheus
cattle-system
cmdb
default
event
harbor
ingress-nginx
istio-project
istio-system
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
file-server-nginx-756bff5899-fnmg6      1/1     Running   0          23d
filebeat-2n9zd                          1/1     Running   0          21h
filebeat-5mbz8                          1/1     Running   0          21h
filebeat-7xh5k                          1/1     Running   0          21h
filebeat-8x8cm                          1/1     Running   0          21h
filebeat-l8kns                          1/1     Running   0          21h
filebeat-sfcfl                          1/1     Running   0          21h
kibana-7b8c4c885-4fmmn                  1/1     Running   0          69d
oa-metting-deployment-5df9d79c9-thp5t   1/1     Running   0          40d
squida-67dd794859-p4l8b                 1/1     Running   1          45d
yum-with-browser                        2/2     Running   0          6d22h
➜  /kube-everything helm ls
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /root/.kube/config
NAME	NAMESPACE	REVISION	UPDATED                               	STATUS  	CHART           	APP VERSION
elk 	default  	2       	2022-03-03 11:34:33.684772 +0800 +0800	deployed	elk-7.6.2
loki	default  	1       	2022-01-27 11:37:57.209311 +0800 +0800	deployed	loki-stack-2.1.2	v2.0.0
```

## 重新编译镜像

可以修改 [Makefile](Makefile) 然后执行 `make`

## TODO

- [ ] 常用的kubectl插件
- [ ] 网络排查工具和脚本
- [ ] 提供参数更新工具版本
- [x] 安装helm
