tmp = *.tex *.pdf
data = data.csv
charts = att-doc-latencies.tex

.PHONY: all
all: $(charts)

$(charts): %.tex: plot-%.R
	Rscript $< $(data)

.PHONY: clean
clean:
	rm -f $(tmp)
