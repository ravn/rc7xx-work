---
name: feedback-python-use-venv
description: Installer aldrig Python-pakker system-wide — brug altid venv (eller pakke der allerede findes system-wide uden pip install).
metadata:
  type: feedback
---

Python-pakker SKAL installeres i et venv, aldrig system-wide via `pip install`.

**Hvorfor:** brugeren bevarer kontrol over systemets Python-miljø og undgår
afhængighedskonflikter mellem projekter. En system-wide `pip install` fra en
agent-session er svær at opdage og trække tilbage senere.

**Sådan anvendes:**
- Hvis en pakke allerede er installeret system-wide (fx `capstone`, `pypdf`
  som vi fandt 2026-10-31), er det OK at bruge den fra `python3`.
- Hvis en ny pakke er nødvendig: opret et venv i projektmappen (fx
  `./.venv`), aktiver det, og installer dér. Dokumentér i README/notes
  hvordan venv aktiveres.
- Spørg hellere brugeren først hvis det er uklart om venv allerede findes
  til projektet.
