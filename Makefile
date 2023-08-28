.PHONY: all paper clean

doc = paper.pdf
deps = paper.tex sections/*.tex sections/figures/*.tex references.bib
charts = diagrams/attestation-document-request-latency/att-doc-latencies.tex \
	 diagrams/http-requests-per-sec/http-requests-per-sec.tex

all: paper

$(charts):
	$(MAKE) -C $(dir $@)

paper: $(deps) $(charts)
	latexmk -pdflatex -quiet paper.tex

clean:
	latexmk -C
