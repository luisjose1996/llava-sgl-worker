#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA
nohup python3 -m llava.serve.controller \
  --host 127.0.0.1 \
  --port ${LLAVA_CONTROLLER_PORT} > /workspace/logs/controller.log 2>&1 &
deactivate
