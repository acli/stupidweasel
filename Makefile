targets=stupidweasel
bindir=$(HOME)/bin

all: check doc

check: $(addsuffix .chk,$(targets))

doc: stupidweasel.8

install: $(addprefix $(bindir)/,$(targets))

$(bindir)/%: %
	perl -cw $< && install -m 755 $< $@

%.chk: %
	perl -cw $<

%.8: %
	pod2man --utf8 --section 8 $< > $@

.DELETE_ON_ERROR:
.PHONEY: all check doc install
