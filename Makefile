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
	perl -nle 'print /^(=head1)(.*)/s? "$$1\U$$2": $$_' $< | pod2man --utf8 --section 8 -n "$(shell echo "$*"|tr '[:lower:]' '[:upper:]')" > $@

.DELETE_ON_ERROR:
.PHONEY: all check doc install
