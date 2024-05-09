#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA

nohup python3 -m sglang.launch_server --model-path ${LLAVA_MODEL} \
  --port ${SGL_ENDPOINT_PORT} --tp 2 > /workspace/logs/sgl-backend.log 2>&1 &
deactivate
