#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA

nohup python3 -m sglang.launch_server --model-path ${LLAVA_MODEL} --port ${SQL_ENDPOINT_PORT} --tp 2 2>&1
deactivate
