targets=stupidweasel
bindir=$(HOME)/bin

all:

install: $(addprefix $(bindir)/,$(targets))

$(bindir)/%: %
	perl -cw $< && install -m 755 $< $@

.DELETE_ON_ERROR:
.PHONEY: all install
