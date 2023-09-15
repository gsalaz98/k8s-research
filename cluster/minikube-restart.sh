sudo -v

minikube start --cpus=4 --memory 12GiB --disk-size 20GiB --nodes=9 --cni=cilium --container-runtime=cri-o --driver=kvm2 --wait=none --auto-update-drivers=false --addons=registry --insecure-registry="10.0.0.0/24" --kubernetes-version=v1.28.3;

echo "Adding minikube IP $(minikube ip) to insecure docker registries...";

if [ -f /etc/docker/daemon.json ]; then
	echo '{"insecure-registries": ["'"$(minikube ip):5000"'"]}' | sudo tee /etc/docker/daemon.json;
else
	jsondata="$(cat /etc/docker/daemon.json | jq '."insecure-registries" += "'"$(minikube ip):5000"'"')";
	echo "${jsondata}" | sudo tee /etc/docker/daemon.json;
fi;

mapfile -t vm_list < <(virsh list --name | awk NF | grep "minikube-m[0-9]\+" | head -n8 | sed 's/ //g');
mapfile -t hdd_list < <(lsblk -o "NAME,MODEL" | grep "WUH721414AL5204" | sed 's/ .*//g' | sed 's/^/\/dev\/\0/g');

echo "Labeling nodes with ceph=true, ceph-partition=vdb labels";
for i in $(seq 0 7); do
	vm_name="${vm_list[$i]}";
	kubectl label node/${vm_name} ceph="true" ceph-partition="vdb";
done;
