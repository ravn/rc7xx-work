---
name: Transcribe image PDFs to text
description: When scanning an image PDF, create a text transcription in the project repo for future use
type: feedback
---

When scanning an image PDF (via Docker poppler), transcribe the content into a text/markdown file in the project repo so it's reusable in future sessions without re-rendering.

**Why:** Image PDFs require Docker + poppler to render, and the rendered PNGs can't be searched or grepped. A text version in the repo is instantly accessible and searchable.

**How to apply:** After reading PDF pages as images, create a `.md` file in the project (e.g. `docs/intel_8275_datasheet.md`) with the transcribed technical content. Focus on tables, register definitions, bit fields, and operational descriptions — skip marketing text and electrical specs unless relevant.
