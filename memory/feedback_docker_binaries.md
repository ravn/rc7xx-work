---
name: Docker for missing binaries
description: Use Docker images to get missing CLI tools instead of asking to install
type: feedback
originSessionId: 57254a72-8bad-4840-ab6e-f5fbc35df805
---
When a binary is missing (e.g. pdftoppm, poppler-utils, pdftotext), use a Docker image to run it instead of suggesting the user install it.

**Why:** No brew on this system, and building from source is heavyweight. Docker is available and fast.

**How to apply:** `docker run --rm -v /path:/data <image> <command>`. Example for poppler:
`docker run --rm -v /tmp:/data minidocks/poppler pdftoppm -png -r 300 /data/file.pdf /data/out`

**Special case — unreadable PDFs (user confirmed 2026-04-16):** When WebFetch returns unusable text for a PDF (scanned, heavy metadata, or image-only), ALWAYS reach for a Docker image to extract or OCR the text. Do not give up and ask the user to provide the content. Pattern:
```
docker run --rm -v /path/to/pdfs:/work ubuntu:24.04 bash -c \
  'apt-get update -qq >/dev/null && apt-get install -qq -y poppler-utils >/dev/null && \
   pdftotext -layout /work/foo.pdf -' > extracted.txt
```
For image-only PDFs, add `tesseract-ocr` to the apt install and OCR page images. This beats "I couldn't read the PDF."
