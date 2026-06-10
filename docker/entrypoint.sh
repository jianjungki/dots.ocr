#!/bin/bash
set -euo pipefail

MODEL_PATH="${MODEL_PATH:-/workspace/weights/DotsOCR}"
if [ ! -d "$MODEL_PATH" ]; then
  echo "Warning: MODEL_PATH '$MODEL_PATH' does not exist. Mount your model weights to this path or set MODEL_PATH."
fi

exec vllm serve "$MODEL_PATH" \
  --tensor-parallel-size "${TENSOR_PARALLEL_SIZE}" \
  --gpu-memory-utilization "${GPU_MEMORY_UTILIZATION}" \
  --chat-template-content-format string \
  --served-model-name "${SERVED_MODEL_NAME}" \
  --trust-remote-code \
  --listen-port "${PORT}"
