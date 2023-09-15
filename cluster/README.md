# Cluster Setup + Hardware Specs

### Host Hardware
CPU: AMD Ryzen 3990x (64 core, 128 threads)
RAM: 256GiB DDR4
Storage: 2TiB SSD
GPU: NVIDIA 3090 Ti

### Cluster
* Kubernetes Version: `v1.28.3`
* Control Plane Nodes: `1`
* Worker Nodes: `8`
* Setup: minikube, KVM guest per node
* Node specs:
  - CPUs: 4
  - Memory: 12GiB
  - Storage: 1x 12.73TiB HDD for Ceph
* CNI: `cilium`
* Container Runtime: `cri-o`
