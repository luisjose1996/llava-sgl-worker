#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA

nohup python -m llava.serve.sglang_worker \
  --host 127.0.0.1 \
  --controller http://localhost:${LLAVA_CONTROLLER_PORT} \
  --port ${LLAVA_MODEL_SGLANG_WORKER_PORT} \
  --worker http://localhost:${LLAVA_MODEL_SGLANG_WORKER_PORT} \
  --sgl-endpoint http://localhost:${SQL_ENDPOINT_PORT} > /workspace/logs/sgl-worker.log 2>&1 &
deactivate
