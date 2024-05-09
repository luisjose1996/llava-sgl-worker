#!/usr/bin/env bash
VENV_PATH=$(cat /workspace/LLaVA/venv_path)

# The endpoint to check
URL="http://localhost:$SGL_ENDPOINT_PORT/get_model_info"

# Wait for the HTTP status to be 200 OK
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)
while [ $HTTP_STATUS -ne 200 ]; do
  echo "Waiting for backend to be up..."
  sleep 1 # Wait for 1 second before trying again
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)
done

echo "SGLang Backend is up - Running script..."
source ${VENV_PATH}/bin/activate
cd /workspace/LLaVA

nohup python -m llava.serve.sglang_worker \
  --host 127.0.0.1 \
  --controller http://localhost:${LLAVA_CONTROLLER_PORT} \
  --port ${LLAVA_MODEL_SGLANG_WORKER_PORT} \
  --worker http://localhost:${LLAVA_MODEL_SGLANG_WORKER_PORT} \
  --sgl-endpoint http://localhost:${SGL_ENDPOINT_PORT} > /workspace/logs/sgl-worker.log 2>&1 &
deactivate
