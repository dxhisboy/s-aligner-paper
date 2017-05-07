FORCE_FONT := Times New Roman
EPS_DIA := $(patsubst %.dia,./%.eps,$(wildcard *.dia))
EPS_ODS := $(patsubst %.ods,./%.eps,$(wildcard *.ods))
EPS_PLT := $(patsubst %.plt,./%.eps,$(wildcard *.plt))

EPS=$(EPS_DIA) $(EPS_ODS) $(EPS_PLT)
PDF=$(patsubst %.eps, %.pdf, $(EPS))
all: $(EPS) $(PDF)
$(EPS_DIA): ./%.eps: %.dia
	dia $< -e tmp.svg
	sed -i "s/font-family:[^;]*/font-family:Times New Roman/g" tmp.svg
	rsvg-convert -f pdf -o $@ tmp.svg
	rm tmp.svg
$(EPS_ODS): ./%.eps: %.ods
	soffice --convert-to pdf $< --headless
	pdftops $(patsubst %.ods, %.pdf, $<) tmp.ps
	rm $(patsubst %.ods, %.pdf, $<)
	ps2eps tmp.ps -f
	rm tmp.ps
	mv tmp.eps $@
$(EPS_PLT): ./%.eps: %.plt
	gnuplot -c $<
	mv $(patsubst %.plt, %.eps, $<) ../

$(PDF): %.pdf: %.eps
	epstopdf $<
