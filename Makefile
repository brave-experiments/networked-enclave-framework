.PHONY: all paper clean

doc = paper.pdf
deps = paper.tex sections/*.tex sections/figures/*.tex references.bib

all: paper

paper: $(deps)
	rubber --pdf paper

clean:
	rubber --clean paper
