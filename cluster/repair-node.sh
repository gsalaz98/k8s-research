#!/bin/bash

kubectl cordon node/$@;
#kubectl drain node/$@ --delete-emptydir-data --ignore-daemonsets --grace-period=0 --force

minikube ssh -n $@ 'curl -s -L "https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64" > jq; chmod +x jq; sudo systemctl stop kubelet; for pod in $(sudo crictl pods -q); do if [[ "$(sudo crictl inspectp $pod | ./jq -r .status.linux.namespaces.options.network)" != "NODE" ]]; then sudo crictl rmp -f $pod; fi; done; sudo crictl rmp -fa; for i in $(sudo crictl ps -a -q); do sudo crictl stop $i; done; sudo crictl rm -fa; sudo crictl rmi --all; sudo systemctl stop crio; sudo rm /var/lib/crio/version; sudo crio wipe -f; sudo umount /var/lib/containers/storage/overlay/*/merged /var/run/containers/storage/overlay-containers/*/userdata/shm; sudo umount /var/lib/containers/storage/overlay; sudo systemctl stop containerd; sudo systemctl disable containerd; sudo systemctl stop docker; sudo systemctl stop podman; sudo systemctl stop podman.socket; sudo systemctl unmask docker.service; sudo systemctl disable docker.service; sudo systemctl disable podman; for i in $(sudo systemctl list-units | grep container | awk '"'"'{print $1}'"'"'); do sudo systemctl stop "$i"; done; sudo systemctl stop /var/lib/containers/storage/overlay; sudo rm -rf /var/lib/containers || echo "Did not delete /var/lib/containers"; sudo rm -rf /var/run/containers || echo "Did not delete /var/run/containers"; sudo systemctl start crio; sudo systemctl start kubelet';

kubectl label node/$@ ceph=true;
kubectl uncordon node/$@;
