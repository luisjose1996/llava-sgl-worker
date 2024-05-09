ARG BASE_IMAGE
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash

# Create and use the Python venv
WORKDIR /
RUN python3 -m venv --system-site-packages /venv

# Install Torch
ARG INDEX_URL
ARG TORCH_VERSION
ARG XFORMERS_VERSION
RUN source /venv/bin/activate && \
    pip3 install --no-cache-dir torch==${TORCH_VERSION} torchvision torchaudio --index-url ${INDEX_URL} && \
    pip3 install --no-cache-dir xformers==${XFORMERS_VERSION} --index-url ${INDEX_URL} && \
    deactivate

# Clone the git repo of LLaVA and set version
ARG LLAVA_COMMIT
RUN git clone https://github.com/ashleykleynhans/LLaVA.git && \
    cd /LLaVA && \
    git checkout ${LLAVA_COMMIT}

# Install the dependencies for LLaVA
WORKDIR /LLaVA
RUN source /venv/bin/activate && \
    pip3 install --upgrade pip && \
    pip3 install wheel && \
    pip3 install -e . && \
    pip3 install ninja && \
    pip3 install flash-attn --no-build-isolation && \
    pip3 install transformers==4.37.2 && \
    pip3 install protobuf && \
    pip3 install "sglang[all]" && \
    pip3 install vllm==0.3.3 && \
    deactivate

# Download the default model
ARG LLAVA_MODEL
ENV MODEL="${LLAVA_MODEL}"
ENV HF_HOME="/"
COPY --chmod=755 scripts/download_models.py /download_models.py
RUN source /venv/bin/activate && \
    pip3 install huggingface_hub && \
    python3 /download_models.py && \
    deactivate

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Set the venv path
ARG VENV_PATH
ENV VENV_PATH=${VENV_PATH}

ARG LLAVA_MODEL_TOKENIZER
ENV MODEL_TOKENIZER="${LLAVA_MODEL_TOKENIZER}"


# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./
RUN cp -f ./tokenizer_config.json /hub/models--dillonlaird--hf-llava-v1.6-34b/snapshots/839935378b0d9cb583628a70cd1090c04db5f643/tokenizer_config.json

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "nohup", "/start.sh" ]
