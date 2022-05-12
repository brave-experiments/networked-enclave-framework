.PHONY: all paper clean

doc = paper.pdf
deps = paper.tex sections/*.tex sections/figures/*.tex references.bib

all: paper

paper: $(deps)
	rubber --pdf paper.tex

clean:
	rm -f $(doc) paper.{aux,bbl,bcf,blg,dvi,log,out,run.xml}
