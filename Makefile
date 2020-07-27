# vi: set sw=8 ts=8 ai sm noet:

user_targets=stupidweasel
system_targets=$(user_targets) mailpost-wrapper

mailpost=/opt/innd/bin/mailpost
mailpost_as=news

ifeq ($(shell id -u), 0)

bindir=/usr/local/sbin
mandir=/usr/local/man
symlinks=mailq mailrm
targets=$(system_targets)

else

bindir=$(HOME)/bin
mandir=$(HOME)/man
symlinks=
targets=$(user_targets)

endif
man8_targets=$(addsuffix .8,$(targets))

all: check doc

check: $(addsuffix .chk,$(targets))

doc: stupidweasel.8

install: $(addprefix $(bindir)/,$(targets)) \
	$(mandir)/man8 \
	$(addprefix $(mandir)/man8/,$(man8_targets))
	for i in $(symlinks); do (cd $(bindir) && if [ ! -f "$$i" ]; then ln -sf stupidweasel "$$i"; elif [ ! -L "$$i" ]; then echo "$$i not installed because it is a file" >&2; elif [ stupidweasel != "`readlink "$$i"`" ]; then echo "$$i not installed because it is a symlink to a different command" >&2; fi ); done

$(bindir)/mailpost-wrapper: mailpost-wrapper
	perl -cw $< && install -o news -g news -m 2755 $< $@

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
