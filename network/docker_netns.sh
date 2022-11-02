#!/usr/bin/env bash

# https://mp.weixin.qq.com/s?__biz=MzI1MDI3NDE1Mg==&mid=2247483889&idx=1&sn=53a64865e5e9fd9ad8c16ffe36d7075f&chksm=e98589f6def200e0f19fd2c91a77de59bc86d3edd6ee7e8db3f2da716ffbedb2dad4d27b0921&scene=21#wechat_redirect

NAMESPACE=$1

if [[ -z $NAMESPACE ]]; then
  ls -l /var/run/docker/netns/
  exit 0
fi

NAMESPACE_FILE=/var/run/docker/netnds/${NAMESPACE}

if [[ ! -f NAMESPACE_FILE ]]; then
  NAMESPACE_FILE=$(docker inspect -f "{{.NetworkSettings.SandboxKey}} $NAMESPACE 2>/dev/null")
fi

if [[ ! -f NAMESPACE_FILE ]]; then
  echo "Cannot open network namespace '$NAMESPACE': No such file or directory"
  exit 1
fi

shift

if [[ $# -lt 1 ]]; then
  echo "No command specified"
  exit 1
fi

nsenter --net=${NAMESPACE_FILE} $@
