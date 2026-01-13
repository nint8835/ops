ARG LLAMA_SWAP_VERSION=183
ARG STABLE_DIFFUSION_CPP_VERSION=master-471-7010bb4

FROM busybox:1.37.0 AS llama-swap-download

ARG LLAMA_SWAP_VERSION

RUN wget https://github.com/mostlygeek/llama-swap/releases/download/v"${LLAMA_SWAP_VERSION}"/llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    tar -zxf llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    rm llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz

FROM registry.fedoraproject.org/fedora:43 AS stable-diffusion-builder

ARG STABLE_DIFFUSION_CPP_VERSION

RUN dnf -y --nodocs --setopt=install_weak_deps=False install \
        clang \
        cmake \
        gcc \
        git \
        glslc \
        mesa-vulkan-drivers \
        vulkan-loader-devel \
    && dnf clean all && rm -rf /var/cache/dnf/*

WORKDIR /build

RUN git clone --recursive --depth 1 --branch "${STABLE_DIFFUSION_CPP_VERSION}" https://github.com/leejet/stable-diffusion.cpp.git && \
    mkdir -p stable-diffusion.cpp/build && \
    cd stable-diffusion.cpp/build && \
    cmake .. -DSD_VULKAN=ON && \
    cmake --build . --config Release --parallel

# TODO: Can I avoid having to use a custom base image for Strix Halo support?
FROM docker.io/kyuz0/amd-strix-halo-toolboxes:vulkan-radv AS runtime

WORKDIR /app

COPY --from=llama-swap-download /llama-swap /usr/local/bin/llama-swap
COPY --from=stable-diffusion-builder /build/stable-diffusion.cpp/build/bin/sd-server /usr/local/bin/sd-server

ENTRYPOINT ["/usr/local/bin/llama-swap"]
