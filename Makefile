MAIN = s-aligner
FIGS = figures
BIB = bib
TEX = #text

TARGETS: $(MAIN).pdf
.PHONY: all clean

tex_files = $(shell find $(TEX) -name '*.tex' -print)
bib_files = $(shell find $(BIB) -name '*.bib' -print)
fig_files = $(shell find $(FIGS) \
		\( -name '*.eps' -print \) -or \( -name '*.epsi' -print \) \
		-or \( -name '*.ps' -print \) -or \( -name '*.png' -print \) \
		-or \( -name '*.fig' -print \) -or \( -name '*.pdf' -print \) \
		-or \( -name '*.data' -print \) -or \( -name '*.plt' -print \) \
	)

$(MAIN).pdf: $(MAIN).tex $(tex_files) $(bib_files) $(fig_files)
	@if test "`which rubber`" != "" ; then \
		TEXMFOUTPUT=`pwd` rubber -d $(MAIN) ; \
	else \
		pdflatex $(MAIN) | tee latex.out ; \
		if grep -q '^LaTeX Warning: Citation.*undefined' latex.out; then \
			bibtex $(MAIN); \
			touch .rebuild; \
		fi ; \
		while [ -f .rebuild -o \
			-n "`grep '^LaTeX Warning:.*Rerun' latex.out`" ]; do \
			rm -f .rebuild; \
			pdflatex $(MAIN) | tee latex.out; \
		done ; \
		rm -f latex.out ; \
	fi

clean:
	@if test "`which rubber`" != "" ; then \
		rubber -d --clean $(MAIN) ; \
	else \
		find . \( -name '*.blg' -print \) -or \( -name '*.aux' -print \) -or \
			\( -name '*.bbl' -print \) -or \( -name '*~' -print \) -or \
			\( -name '*.lof' -print \) -or \( -name '*.lot' -print \) -or \
			\( -name '*.toc' -print \) | xargs rm -f; \
		rm -f $(MAIN).dvi $(MAIN).log $(MAIN).ps $(MAIN).pdf $(MAIN).out \
			_region_* TAGS ; \
	fi
