# vi: set sw=8 ts=8 ai sm noet:

targets=stupidweasel
man8_targets=stupidweasel.8

bindir=$(HOME)/bin
mandir=$(HOME)/man

all: check doc

check: $(addsuffix .chk,$(targets))

doc: stupidweasel.8

install: $(addprefix $(bindir)/,$(targets)) \
	$(mandir)/man8 \
	$(addprefix $(mandir)/man8/,$(man8_targets))

$(bindir)/%: %
	perl -cw $< && install -m 755 $< $@

$(mandir)/man8:
	mkdir -p $@

$(mandir)/man8/%: %
	install -m 644 $< $@

%.chk: %
	perl -cw $<

%.8: %
	perl -nle 'print /^(=head1)(.*)/s? "$$1\U$$2": $$_' $< | pod2man --utf8 --section 8 -c 'System Management Manual' -n "$(shell echo "$*"|tr '[:lower:]' '[:upper:]')" > $@

.DELETE_ON_ERROR:
.PHONEY: all check doc install
