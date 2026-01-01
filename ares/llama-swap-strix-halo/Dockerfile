FROM busybox:1.37.0 AS llama-swap-download

ARG LLAMA_SWAP_VERSION=182

RUN wget https://github.com/mostlygeek/llama-swap/releases/download/v"${LLAMA_SWAP_VERSION}"/llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    tar -zxf llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    rm llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz

# TODO: Can I avoid having to use a custom base image for Strix Halo support?
FROM docker.io/kyuz0/amd-strix-halo-toolboxes:vulkan-radv AS runtime

WORKDIR /app

COPY --from=llama-swap-download /llama-swap /usr/local/bin/llama-swap

ENTRYPOINT ["/usr/local/bin/llama-swap"]
