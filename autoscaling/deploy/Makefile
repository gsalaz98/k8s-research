.PHONY:
build:
	docker build -t $(shell minikube ip):5000/connectivity-server:local-testing ./failure_modes/
	docker push $(shell minikube ip):5000/connectivity-server:local-testing
	helm uninstall autoscaling-research || echo "Not installed, continue with installation"
	helm install autoscaling-research --set-string registryHost="$(shell minikube ip):5000/" ./

.PHONY:
clean:
	helm uninstall autoscaling-research --wait
