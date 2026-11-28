FROM debian:12-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr tesseract-ocr-dan tesseract-ocr-eng \
    poppler-utils imagemagick \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /work
