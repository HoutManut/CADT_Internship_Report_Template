# Builds report.pdf from two pieces: the Typst-compiled body (src/report.typ)
# and out/report-header.pdf (exported by hand from src/report-header.docx),
# overlaid onto the body's leading blank pages. See config.typ for why.

import logging
import re
import time
import argparse
import subprocess
from pathlib import Path
from threading import Timer
from pypdf import PdfReader, PdfWriter
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

ROOT_DIR = Path(__file__).resolve().parent
OUT_DIR = ROOT_DIR / "out"
BODY_TYP = ROOT_DIR / "src" / "report.typ"
CONFIG_TYP = ROOT_DIR / "src" / "config.typ"
BODY_PDF = OUT_DIR / "report-body.pdf"
HEADER_PDF = OUT_DIR / "report-header.pdf"

logging.getLogger("pypdf").setLevel(logging.ERROR)


def _expected_header_page_count() -> int | None:
    # Cross-checks report-header.pdf against config.typ's header-page-count
    # so a stale docx export doesn't silently misalign onto the wrong pages.
    match = re.search(r"header-page-count\s*=\s*(\d+)", CONFIG_TYP.read_text())
    return int(match.group(1)) if match else None


class BuildOrchestrator:
    def __init__(self, output_pdf: Path, strict: bool = False, fast: bool = False):
        self.output_pdf = output_pdf
        self.strict = strict
        self.fast = fast
        self._debounce_timer = None

    def merge_pdfs(self) -> None:
        if not (HEADER_PDF.exists() and BODY_PDF.exists()):
            print(f"⚠️  Missing PDFs in {OUT_DIR}")
            return

        try:
            writer = PdfWriter()
            body_reader = PdfReader(str(BODY_PDF))
            writer.clone_document_from_reader(body_reader)

            if body_reader.metadata:
                writer.add_metadata(body_reader.metadata)

            header_reader = PdfReader(str(HEADER_PDF))
            expected = _expected_header_page_count()
            if expected is not None and len(header_reader.pages) != expected:
                print(
                    f"\033[93m⚠ WARNING:\033[0m report-header.pdf has "
                    f"{len(header_reader.pages)} page(s) but config.typ's "
                    f"header-page-count is {expected} — re-export the docx "
                    "or update config.typ."
                )
            for i, page in enumerate(header_reader.pages):
                if i < len(writer.pages):
                    writer.pages[i].merge_page(page)

            with self.output_pdf.open("wb") as f:
                writer.write(f)
            print(f"\033[92m✔ SUCCESS:\033[0m Built {self.output_pdf.name}")
        except Exception as e:
            print(f"\033[91m✘ MERGE ERROR:\033[0m {e}")

    def run_build(self):
        if not self.strict:
            print("\033[94m⏳ Compiling...\033[0m")
        else:
            print("\033[94m⏳ Compiling in compliance mode...\033[0m")
        cmd = ["typst", "compile", str(BODY_TYP), str(BODY_PDF)]
        if self.strict:
            cmd[2:2] = ["--pdf-standard", "ua-1"]
        try:
            subprocess.run(cmd, check=True)
            self.merge_pdfs()
        except subprocess.CalledProcessError:
            print("\033[91m✘ TYPST ERROR:\033[0m Check src/report.typ for syntax errors.")

    def debounced_build(self, delay=0.4):
        if self._debounce_timer:
            self._debounce_timer.cancel()
        self._debounce_timer = Timer(delay, self.run_build)
        self._debounce_timer.start()


class TypstWatcher(FileSystemEventHandler):
    def __init__(self, orchestrator: BuildOrchestrator):
        self.orch = orchestrator

    def _relevant(self, path: str) -> bool:
        return path.endswith((".typ", ".bib"))

    def on_modified(self, event):
        if self._relevant(str(event.src_path)):
            self.orch.debounced_build()

    def on_created(self, event):
        if self._relevant(str(event.src_path)):
            self.orch.debounced_build()

    def on_moved(self, event):
        if self._relevant(str(event.dest_path)):
            self.orch.debounced_build()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--watch", action="store_true")
    # CONFIGURE: change the default here if you'd rather not pass --name every time
    parser.add_argument("--name", default="report", help="Output PDF filename (without .pdf)")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Add the PDF/UA-1 accessibility conformance (--pdf-standard ua-1). "
        "Off by default.",
    )
    args = parser.parse_args()

    output_pdf = ROOT_DIR / f"{args.name}.pdf"
    orchestrator = BuildOrchestrator(output_pdf, strict=args.strict)
    orchestrator.run_build()

    if args.watch:
        handler = TypstWatcher(orchestrator)
        observer = Observer()
        observer.schedule(handler, str(ROOT_DIR / "src"), recursive=True)
        print(f"\033[1m🚀 WATCHING:\033[0m {ROOT_DIR / 'src'}")
        observer.start()
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()
        observer.join()


def watch():
    import sys
    sys.argv.append("--watch")
    main()


if __name__ == "__main__":
    main()
