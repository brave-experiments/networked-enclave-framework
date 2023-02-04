.PHONY: all paper clean

doc = paper.pdf
deps = paper.tex sections/*.tex sections/figures/*.tex references.bib

all: paper

paper: $(deps)
	latexmk -pdflatex -quiet paper.tex

clean:
	latexmk -C
