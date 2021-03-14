CONTENT=figures/*.pdf references.bib
OMIT=main.aux main.fdb_latexmk main.blg main.fls mainNotes.bib main.log main.out main.bbl references.bib main.pdf
all: main.pdf

# -pdf tells latexmk to generate a PDF instead of DVI.
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
# -synctex=1 is required to jump between the source PDF and the text editor.
# -pvc (preview continuously) watches the directory for changes.
# -quiet suppresses most status messages (https://tex.stackexchange.com/questions/40783/can-i-make-latexmk-quieter).
main.pdf: main.tex
	latexmk -quiet -bibtex $(PREVIEW_CONTINUOUSLY) -f -pdf -pdflatex="pdflatex -synctex=1 -interaction=nonstopmode" -use-make main.tex

# The .PHONY rule keeps make from processing a file named "watch" or "clean".
.PHONY: watch
# Set the PREVIEW_CONTINUOUSLY variable to -pvc to switch latexmk into the preview continuously mode
watch: PREVIEW_CONTINUOUSLY=-pvc
watch: main.pdf

.PHONY: figures
figures:
	@echo "Converting SVG figures to PDF..."
	@cd figures && for f in *.svg; do \
		echo $$f ; \
		b=$$(basename $$f .svg) ; \
		inkscape --export-filename="$$b.pdf" $$f ; done

.PHONY: clean
# -bibtex also removes the .bbl files (http://tex.stackexchange.com/a/83384/79184).
clean:
	latexmk -C -bibtex
