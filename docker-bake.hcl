variable "REGISTRY" {
    default = "docker.io"
}

variable "REGISTRY_USER" {
    default = "luisnaveda"
}

variable "APP" {
    default = "llava"
}

variable "RELEASE" {
    default = "1.7.0"
}

variable "CU_VERSION" {
    default = "118"
}

variable "BASE_IMAGE_REPOSITORY" {
    default = "ashleykza/runpod-base"
}

variable "BASE_IMAGE_VERSION" {
    default = "1.0.2"
}

variable "CUDA_VERSION" {
    default = "11.8.0"
}

variable "TORCH_VERSION" {
    default = "2.1.2"
}

target "default" {
    dockerfile = "Dockerfile"
    tags = ["${REGISTRY}/${REGISTRY_USER}/${APP}:${RELEASE}"]
    args = {
        RELEASE = "${RELEASE}"
        BASE_IMAGE = "${BASE_IMAGE_REPOSITORY}:${BASE_IMAGE_VERSION}-cuda${CUDA_VERSION}-torch${TORCH_VERSION}"
        INDEX_URL = "https://download.pytorch.org/whl/cu${CU_VERSION}"
        TORCH_VERSION = "${TORCH_VERSION}+cu${CU_VERSION}"
        XFORMERS_VERSION = "0.0.23.post1+cu${CU_VERSION}"
        LLAVA_COMMIT = "0b3b478e7cc8e55d7ca312ecd2ff5a90690d08d5"
        LLAVA_MODEL = "dillonlaird/hf-llava-v1.6-34b",
        LLAVA_MODEL_TOKENIZER="llava-hf/llava-v1.6-mistral-7b-hf"
        VENV_PATH = "/workspace/venvs/${APP}"
    }
}
