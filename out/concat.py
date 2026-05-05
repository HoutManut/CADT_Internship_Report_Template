from pathlib import Path
from typing import Sequence
from pypdf import PdfReader, PdfWriter


def merge_pdfs_with_header_overlay(
    header_path: Path,
    body_path: Path,
    output_path: Path,
) -> None:
    header_reader = PdfReader(str(header_path))
    body_reader = PdfReader(str(body_path))
    writer = PdfWriter()

    header_page_count = len(header_reader.pages)

    for i, body_page in enumerate(body_reader.pages):
        if i < header_page_count:
            # Merge header page on top of the corresponding body page
            body_page.merge_page(header_reader.pages[i])
        writer.add_page(body_page)

    with output_path.open("wb") as out:
        writer.write(out)


if __name__ == "__main__":
    output_dir = next(Path(__file__).resolve().parent.parent.glob("out/"))
    header_file = output_dir / "report-header.pdf"
    body_file = output_dir / "report-body.pdf"
    output_file = output_dir.parent / "report.pdf"

    merge_pdfs_with_header_overlay(header_file, body_file, output_file)
