#!/bin/bash

echo "K8S_CLASS=intro"  >> /home/ubuntu/.k8s_env
echo "K8S_ROLE=master"  >> /home/ubuntu/.k8s_env

cat <<EOF >> /home/ubuntu/.bashrc
export STRIGO_EVENT_ID="{{ .STRIGO_EVENT_ID }}"
export STRIGO_EVENT_NAME="{{ .STRIGO_EVENT_NAME }}"
export STRIGO_CLASS_ID="{{ .STRIGO_CLASS_ID }}"
export STRIGO_CLASS_NAME="{{ .STRIGO_CLASS_NAME }}"
export STRIGO_USER_ID="{{ .STRIGO_USER_ID }}"
export STRIGO_USER_EMAIL="{{ .STRIGO_USER_EMAIL }}"
export STRIGO_USER_NAME="{{ .STRIGO_USER_NAME }}"
export STRIGO_ORG_ID="{{ .STRIGO_ORG_ID }}"
export STRIGO_ORG_NAME="{{ .STRIGO_ORG_NAME }}"
export STRIGO_PARTNER_ID="{{ .STRIGO_PARTNER_ID }}"
export STRIGO_PARTNER_NAME="{{ .STRIGO_PARTNER_NAME }}"
export STRIGO_WORKSPACE_ID="{{ .STRIGO_WORKSPACE_ID }}"
export STRIGO_WORKSPACE_FLAVOR="{{ .STRIGO_WORKSPACE_FLAVOR }}"
export STRIGO_RESOURCE_NAME="{{ .STRIGO_RESOURCE_NAME }}"
export STRIGO_EVENT_HOST_EMAIL="{{ .STRIGO_EVENT_HOST_EMAIL }}"
export STRIGO_RESOURCE_0_ID="{{ .STRIGO_RESOURCE_0_ID }}"
export STRIGO_RESOURCE_0_NAME="{{ .STRIGO_RESOURCE_0_NAME }}"
export STRIGO_RESOURCE_0_DNS="{{ .STRIGO_RESOURCE_0_DNS }}"
export STRIGO_RESOURCE_1_ID="{{ .STRIGO_RESOURCE_1_ID }}"
export STRIGO_RESOURCE_1_NAME="{{ .STRIGO_RESOURCE_1_NAME }}"
export STRIGO_RESOURCE_1_DNS="{{ .STRIGO_RESOURCE_1_DNS }}"
export STRIGO_RESOURCE_2_ID="{{ .STRIGO_RESOURCE_2_ID }}"
export STRIGO_RESOURCE_2_NAME="{{ .STRIGO_RESOURCE_2_NAME }}"
export STRIGO_RESOURCE_2_DNS="{{ .STRIGO_RESOURCE_2_DNS }}"
EOF

hostnamectl set-hostname master

docker pull ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version}
docker tag ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version} lab-docs:${version}
docker rmi ${CONTAINER_REGISTRY}/${CONTAINER_REPOSITORY}:${version}
docker run -d -p 8081:8080 --name lab-docs --restart always lab-docs:${version}

wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 3 http://localhost:8081/_static/lab-ff.sh -O /usr/local/bin/lab-ff
chmod 755 /usr/local/bin/lab-ff