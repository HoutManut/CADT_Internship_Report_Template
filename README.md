# CADT report template written with Typst

## Setup

### 1. Install the [Typst Compiler](https://typst.app/open-source/#download)
### 2. Install Python
Then
```python
pip install pypdf watchdog
```


### Optional stuff

1. **Install the [Fira Code](https://github.com/tonsky/FiraCode) font:** Used for all monospace texts. but more importantly, it enables the folder tree figure to render correctly.
2. **Install the [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) VSCode extension**

## Usage

The report splits into 2:

### The Header
Located at `src/report-header.docx`. This only contains the first 3 pages of the report. **Fill it with the project topic, logo, names, and dates.**

After that, export it as a **PDF** to `out/report-header.pdf`.


### The Body (the rest)
Entry point at `src/report.typ`. Contains everything else for the report.

Chapter contents are written as separate files under `src/chapters/`. Add or rename the files as needed but make sure the names are correct inside `src/report.typ`.

This repo contains a rough outline that closely follows CADT's provided internship report template. Treat the content as an example, and I suggest changing the sub sections since this is just my report stripped out of any content.

## Building

### Compile (once)
```python
python out/concat.py
```

### Watch (compile on save)
```python
python out/concat.py --watch
```

