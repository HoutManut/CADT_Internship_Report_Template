import logging
import time
import argparse
import subprocess
from pathlib import Path
from threading import Timer
from pypdf import PdfReader, PdfWriter
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# --- Dynamic Path Configuration ---
SCRIPT_FILE = Path(__file__).resolve()
ROOT_DIR = SCRIPT_FILE.parent

# Input Sources (in src/)
BODY_TYP = ROOT_DIR / "src" / "report.typ"

# Intermediate PDFs (in out/)
BODY_PDF = ROOT_DIR / "out" / "report-body.pdf"
HEADER_PDF = ROOT_DIR / "out" / "report-header.pdf"

# Final Result (sits in project root)
OUTPUT_PDF = ROOT_DIR / "report.pdf"

logging.getLogger("pypdf").setLevel(logging.ERROR)
class BuildOrchestrator:
    def __init__(self):
        self._debounce_timer = None

    def merge_pdfs(self) -> None:
        if not (HEADER_PDF.exists() and BODY_PDF.exists()):
            print(f"⚠️  Waiting for PDFs to exist in {SCRIPT_FILE}...")
            return

        try:
            writer = PdfWriter()
            body_reader = PdfReader(str(BODY_PDF))
            writer.clone_document_from_reader(body_reader)

            if body_reader.metadata:
                writer.add_metadata(body_reader.metadata)

            header_reader = PdfReader(str(HEADER_PDF))
            for i, header_page in enumerate(header_reader.pages):
                if i < len(writer.pages):
                    writer.pages[i].merge_page(header_page)

            with OUTPUT_PDF.open("wb") as out:
                writer.write(out)
            print(f"\033[92m✔ SUCCESS:\033[0m Built {OUTPUT_PDF.name}")
        except Exception as e:
            print(f"\033[91m✘ MERGE ERROR:\033[0m {e}")

    def run_build(self):
        print("\033[94m⏳ Compiling Typst...\033[0m")
        try:
            subprocess.run(["typst", "compile", str(
                BODY_TYP), str(BODY_PDF)], check=True)

            self.merge_pdfs()
        except subprocess.CalledProcessError:
            print(
                "\033[91m✘ TYPST ERROR:\033[0m Check src/report.typ for syntax errors.")

    def debounced_build(self, delay=0.4):
        if self._debounce_timer:
            self._debounce_timer.cancel()
        self._debounce_timer = Timer(delay, self.run_build)
        self._debounce_timer.start()


class TypstWatcher(FileSystemEventHandler):
    def __init__(self, orchestrator):
        self.orch = orchestrator

    def on_modified(self, event):
        # Watch the 'src' folder for any .typ or .bib changes
        if event.src_path.endswith((".typ", ".bib")):
            self.orch.debounced_build()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--watch", action="store_true")
    args = parser.parse_args()

    orchestrator = BuildOrchestrator()

    # Run initial build
    orchestrator.run_build()

    if args.watch:
        event_handler = TypstWatcher(orchestrator)
        observer = Observer()
        # Watch the SRC directory specifically
        observer.schedule(event_handler, str(ROOT_DIR / "src"), recursive=True)

        print(f"\033[1m🚀 WATCHING SRC FOLDER\033[0m")
        observer.start()
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()
        observer.join()


if __name__ == "__main__":
    main()
