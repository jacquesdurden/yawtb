all: clean update cleancode

update:
	cp /net/tmp_daily/yawtb/doc/tex/*.ps.gz .
	cp /net/tmp_daily/yawtb/doc/tex/*.pdf .
	find /net/tmp_daily/yawtb/doc/html/ -type f -maxdepth 1 -exec cp {} . \;
cleancode:
	rm -f *.aux *.tex *.dvi *.pl *.log
	rm -f WARNINGS
clean:
	rm -f *.html
	rm -f *.png
	rm -f *.ps.gz *.pdf
