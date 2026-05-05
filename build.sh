#!/bin/bash
set -e
typst compile src/report.typ out/report-body.pdf
python3 out/concat.py
