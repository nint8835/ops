.PHONY: fetch-kubeconfig fetch-talosconfig fetch-configs lint fix

fetch-kubeconfig:
	mkdir -p $(HOME)/.kube
	tofu output --raw kubeconfig > ~/.kube/config

fetch-talosconfig:
	mkdir -p $(HOME)/.talos
	tofu output --raw talosconfig > ~/.talos/config

fetch-configs: fetch-kubeconfig fetch-talosconfig

lint:
	tofu fmt -check -recursive
	tflint --config "$(CURDIR)/.tflint.hcl" --recursive
	tofu validate

fix:
	tflint --config "$(CURDIR)/.tflint.hcl" --recursive --fix
	tofu fmt -recursive
