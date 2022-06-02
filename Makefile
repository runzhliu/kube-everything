all: build push

build:
	docker build --network=host --build-arg https_proxy=socks5://ss.fenqile.cn:10050 --build-arg http_proxy=socks5://ss.fenqile.cn:10050 -t runzhliu/kube-everything .

push:
	docker push runzhliu/kube-everything
