# This dockerfile is _heavily_ based on the fantastic work done by kyuz0 on the amd-strix-halo-toolboxes project
# https://github.com/kyuz0/amd-strix-halo-toolboxes

ARG LLAMA_CPP_VERSION=b8122
ARG LLAMA_SWAP_VERSION=194
ARG STABLE_DIFFUSION_CPP_VERSION=master-505-c5eb1e4

FROM registry.fedoraproject.org/fedora:43 AS build-deps

RUN dnf install -y --nodocs --setopt=install_weak_deps=False \
        clang \
        cmake \
        gcc \
        git \
        glslc \
        mesa-vulkan-drivers \
        ninja-build \
        vulkan-loader-devel \
        wget \
    && dnf clean all && rm -rf /var/cache/dnf/*

FROM build-deps AS stable-diffusion-builder

ARG STABLE_DIFFUSION_CPP_VERSION

WORKDIR /build

RUN git clone --recursive --depth 1 --branch "${STABLE_DIFFUSION_CPP_VERSION}" https://github.com/leejet/stable-diffusion.cpp.git && \
    mkdir -p stable-diffusion.cpp/build && \
    cd stable-diffusion.cpp/build && \
    cmake .. -G Ninja -DSD_VULKAN=ON && \
    cmake --build . --config Release --parallel

FROM build-deps AS llama-cpp-builder

ARG LLAMA_CPP_VERSION

WORKDIR /build

# TODO: This is compiling ggml as well - can I make only one of these handle compiling it?
RUN git clone --recursive --depth 1 --branch "${LLAMA_CPP_VERSION}" https://github.com/ggml-org/llama.cpp.git && \
    cd llama.cpp && \
    cmake \
        -B build \
        -G Ninja \
        -DGGML_VULKAN=1 \
        -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build build --config Release --parallel && \
    cmake --install build --config Release

FROM build-deps AS llama-swap-download

ARG LLAMA_SWAP_VERSION

RUN wget https://github.com/mostlygeek/llama-swap/releases/download/v"${LLAMA_SWAP_VERSION}"/llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    tar -zxf llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz && \
    rm llama-swap_"${LLAMA_SWAP_VERSION}"_linux_amd64.tar.gz

FROM registry.fedoraproject.org/fedora-minimal:43 AS runtime

WORKDIR /app

RUN microdnf install -y --nodocs --setopt=install_weak_deps=0 \
        libgomp \
        mesa-vulkan-drivers \
        vulkan-loader \
    && microdnf clean all && rm -rf /var/cache/dnf/*

RUN echo "/usr/local/lib"  > /etc/ld.so.conf.d/local.conf && \
    echo "/usr/local/lib64" >> /etc/ld.so.conf.d/local.conf

COPY --from=llama-swap-download /llama-swap /usr/local/bin/llama-swap
COPY --from=stable-diffusion-builder /build/stable-diffusion.cpp/build/bin/sd-server /usr/local/bin/sd-server

COPY --from=llama-cpp-builder /usr/local/bin/llama-server /usr/local/bin/llama-server
COPY --from=llama-cpp-builder /usr/local/bin/llama-bench /usr/local/bin/llama-bench
COPY --from=llama-cpp-builder /usr/local/lib64/ /usr/local/lib64/

RUN ldconfig

ENTRYPOINT ["/usr/local/bin/llama-swap"]
