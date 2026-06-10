FROM vllm/vllm-openai:latest

WORKDIR /workspace

COPY requirements.txt setup.py /workspace/
COPY dots_ocr /workspace/dots_ocr
COPY demo /workspace/demo
COPY assets /workspace/assets
COPY tools /workspace/tools
COPY LICENSE README.md /workspace/

RUN python3 -m pip install --upgrade pip setuptools wheel \
    && python3 -m pip install -r requirements.txt \
    && python3 -m pip install -e .

RUN python3 - <<'PY'
from pathlib import Path
entry = Path('/usr/local/bin/vllm')
if not entry.exists():
    entry = Path('/usr/bin/vllm')
if entry.exists():
    text = entry.read_text()
    marker = 'from vllm.entrypoints.cli.main import main'
    if marker in text and 'from DotsOCR import modeling_dots_ocr_vllm' not in text:
        text = text.replace(marker,
            marker + '\ntry:\n    from DotsOCR import modeling_dots_ocr_vllm\nexcept Exception:\n    pass')
        entry.write_text(text)
PY

ENV PYTHONPATH=/workspace
ENV MODEL_PATH=/workspace/weights/DotsOCR
ENV TENSOR_PARALLEL_SIZE=1
ENV GPU_MEMORY_UTILIZATION=0.8
ENV SERVED_MODEL_NAME=dotsocr-model
ENV PORT=8000

EXPOSE 8000
COPY docker/entrypoint.sh /workspace/entrypoint.sh
RUN chmod +x /workspace/entrypoint.sh

ENTRYPOINT ["/workspace/entrypoint.sh"]
