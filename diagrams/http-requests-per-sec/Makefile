tmp = *.tex *.pdf
data = data.csv
charts = http-requests-per-sec.tex

.PHONY: all
all: $(charts)

$(charts): %.tex: plot-%.R $(data)
	Rscript $< $(data)

.PHONY: clean
clean:
	rm -f $(tmp)
