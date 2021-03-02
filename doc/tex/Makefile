all:    clean latex postscript pdf ps.gz html

latex:
	./DocProcess.pl

postscript:
	latex YAWTBReferenceManual.tex
	latex YAWTBReferenceManual.tex
	dvips YAWTBReferenceManual.dvi -o
	
ps.gz:
	gzip YAWTBReferenceManual.ps
	
pdf:
	ps2pdf YAWTBReferenceManual.ps

html:
	latex2html YAWTBReferenceManual.tex

clean:
	rm -fv TMP_* *.log *.aux *.ps *.ps.gz *.pdf *.toc *.dvi
	rm -fv ../html/WARNINGS ../html/*.html ../html/*.css 
	rm -fv ../html/*.png ../html/*.pl ../html/image*
	rm -rfv ../html/TMP

clean_code:
	rm -fv TMP_* *.log *.aux *.toc *.dvi
	rm -fv ../html/*.log ../html/*.aux ../html/*.tex ../html/*.pl	
