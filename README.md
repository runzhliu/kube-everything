# kube-everything

The main purpose of this project is to use an image to configure the software and aliases that are usually used in the k8s development process at one time, so that no matter how I switch the environment, as long as I have Docker, I can use it smoothly.

## Tools in Dockerfile

The details are all in [Dockerfile](Dockerfile), you can take a closer look, if you want to add something, you can add it casually.

## Docker Hub Image

```shell
docker pull runzhliu/kube-everything:latest
# the directory mounted by /root/.kube
cp ~/.kube/config /tmp/config && docker run -v /tmp/config:/root/.kube/config --net=host -it runzhliu/kube-everything:latest
# catch the help infos
cat help
# for containerd, please use nerdctl
cp ~/.kube/config /tmp/config && nerdctl run -v /tmp/config:/root/.kube/config --net=host -it runzhliu/kube-everything:latest
```

## Usage Examples

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

## Re-build

Revise [Makefile](Makefile), then run `make`