#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA

pip install "sglang[all]"
pip install vllm==0.3.3


python3 -m sglang.launch_server --model-path ${LLAVA_MODEL} --tokenizer-path ${LLAVA_MODEL_TOKENIZER} --port ${SQL_ENDPOINT_PORT} --tp 2

nohup python -m llava.serve.sglang_worker \
  --host ${LLAVA_HOST} \
  --controller http://localhost:${LLAVA_CONTROLLER_PORT} \
  --port ${LLAVA_MODEL_SGLANG_WORKER_PORT} \
  --worker http://localhost:${LLAVA_MODEL_SGLANG_WORKER_PORT} \
  --sgl-endpoint http://localhost:${SQL_ENDPOINT_PORT} 2>&1 &
deactivate
