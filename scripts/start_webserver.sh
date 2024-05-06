#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA
nohup python -m llava.serve.gradio_web_server \
  --controller http://localhost:${LLAVA_CONTROLLER_PORT} \
  --model-list-mode reload > /workspace/logs/webserver.log 2>&1 &
deactivate
