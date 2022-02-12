# Cluster Setup

- Create a server node, following the [Adding a Node](./adding-a-node.md) guide, with the following tweaks
    - Set up the node as a server rather than as an agent
    - Give it a custom cluster token, and make note of this value
- [Install the Flux CLI](https://fluxcd.io/docs/installation/#install-the-flux-cli)
- Create a personal access token for Flux, and set it as the `GITHUB_TOKEN` environment variable
- Bootstrap the Flux install
  ```fish
  flux bootstrap github \
      --owner=nint8835 \
      --repository=ops \
      --branch=master \
      --path=./cluster \
      --personal
  ```
- Following the [docs](https://fluxcd.io/docs/guides/mozilla-sops), add a GPG key for SOPS
