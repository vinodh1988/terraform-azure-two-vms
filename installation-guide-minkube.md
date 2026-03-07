# Minikube Installation Guide (Ubuntu 24.04)

This guide installs Minikube on Ubuntu 24.04 using the Docker driver.

## 1. Install prerequisites

```bash
sudo apt update
sudo apt install -y curl ca-certificates conntrack docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

## 2. Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

## 3. Install Minikube

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
```

## 4. Start Minikube

```bash
minikube start --driver=docker
```

## 5. Verify cluster

```bash
kubectl get nodes
minikube status
```

## 6. Useful commands

```bash
minikube dashboard
minikube stop
minikube delete
```

## Notes

- If Docker permission is denied, log out and log back in (or reboot) to refresh group membership.
- If this VM was provisioned with cloud-init Docker setup, these steps still apply for kubectl and Minikube.
