.PHONY: doc html clean check

GAP ?= gap
GAP_ARGS = -q --quitonbreak --packagedirs $(abspath .)

doc:
	$(GAP) $(GAP_ARGS) makedoc.g -c 'QUIT;'

html:
	NOPDF=1 $(GAP) $(GAP_ARGS) makedoc.g -c 'QUIT;'

clean:
	cd doc && ./clean

check:
	$(GAP) $(GAP_ARGS) tst/testall.g
