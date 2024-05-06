#!/usr/bin/env python3
import os
from huggingface_hub import snapshot_download


if __name__ == '__main__':
    model = os.getenv('MODEL', 'liuhaotian/llava-v1.6-mistral-7b')
    tokenizer = os.getenv('MODEL_TOKENIZER', 'llava-hf/llava-v1.6-mistral-7b-hf')

    print(f'Downloading LLaVA model: {model}')
    snapshot_download(model)

    # print(f'Downloading CLIP model: {clip_model}')
    # snapshot_download(clip_model)

    print(f'Downloading Tokenzier model: {tokenizer}')
    snapshot_download(tokenizer)

