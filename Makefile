all: build push

build:
	docker build --network=host --build-arg https_proxy= --build-arg http_proxy= -t runzhliu/kube-everything .

push:
	docker push runzhliu/kube-everything
