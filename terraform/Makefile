fetch-kubeconfig:
	mkdir -p $(HOME)/.kube
	tofu output --raw kubeconfig > ~/.kube/config

fetch-talosconfig:
	mkdir -p $(HOME)/.talos
	tofu output --raw talosconfig > ~/.talos/config

fetch-configs: fetch-kubeconfig fetch-talosconfig

lint:
	tflint --config $$(pwd)/.tflint.hcl --recursive --fix
	tofu validate
