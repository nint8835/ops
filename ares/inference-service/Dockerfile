# This dockerfile is _heavily_ based on the fantastic work done by kyuz0 on the amd-strix-halo-toolboxes project
# https://github.com/kyuz0/amd-strix-halo-toolboxes

ARG LLAMA_SWAP_VERSION=186
ARG STABLE_DIFFUSION_CPP_VERSION=master-484-fa61ea7

FROM registry.fedoraproject.org/fedora:43 AS build-deps

RUN dnf install -y --nodocs --setopt=install_weak_deps=False \
        clang \
        cmake \
        gcc \
        git \
        glslc \
        mesa-vulkan-drivers \
        vulkan-loader-devel \
        wget \
    && dnf clean all && rm -rf /var/cache/dnf/*

FROM build-deps AS stable-diffusion-builder

ARG STABLE_DIFFUSION_CPP_VERSION

WORKDIR /build

RUN git clone --recursive --depth 1 --branch "${STABLE_DIFFUSION_CPP_VERSION}" https://github.com/leejet/stable-diffusion.cpp.git && \
    mkdir -p stable-diffusion.cpp/build && \
    cd stable-diffusion.cpp/build && \
    cmake .. -DSD_VULKAN=ON && \
    cmake --build . --config Release --parallel

FROM build-deps AS llama-swap-download

ARG LLAMA_SWAP_VERSION

RUN wget https://github.com/mostlygeek/llama-swap/releases/download/v"${LLAMA_SWAP_VERSION}"/llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    tar -zxf llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    rm llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz

FROM registry.fedoraproject.org/fedora-minimal:43

WORKDIR /app

RUN microdnf install -y --nodocs --setopt=install_weak_deps=0 \
        libgomp \
        mesa-vulkan-drivers \
        vulkan-loader \
    && microdnf clean all && rm -rf /var/cache/dnf/*

COPY --from=llama-swap-download /llama-swap /usr/local/bin/llama-swap
COPY --from=stable-diffusion-builder /build/stable-diffusion.cpp/build/bin/sd-server /usr/local/bin/sd-server

ENTRYPOINT ["/usr/local/bin/llama-swap"]
