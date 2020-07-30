# vi: set sw=8 ts=8 ai sm noet:

# user_bin_targets - what scripts to install if installing as non-root
user_bin_targets=stupidweasel slgw

# system_bin_targets - what scripts to install if installing as root
system_bin_targets=$(user_bin_targets) mailpostgw
system_dat_targets=lists.dat

# man8_targets - what man pages to install
man8_targets=stupidweasel.8 slgw.8 mailpostgw.8

# mailpost - where is the mailpost command
mailpost=/software/inn/bin/mailpost

# mailpost_as - what user should mailpost be run as
mailpost_as=news

# system_bindir - where should scripts be installed if installing as root
system_bindir=/usr/local/sbin

# system_datdir - where should data files be installed if installing as root
system_datdir=/usr/local/etc

# system_mandir - where should man pages be installed if installing as root
system_mandir=/usr/local/man

####################### END OF CONFIGURABLE OPTIONS #######################

ifeq ($(shell id -u), 0)

bindir=$(system_bindir)
datdir=$(system_datdir)
mandir=$(system_mandir)
symlinks=mailq mailrm
targets=$(system_bin_targets)
dat_targets=$(system_dat_targets)

else

bindir=$(HOME)/bin
datdir=$(HOME)/.config/stupidweasel
mandir=$(HOME)/man
symlinks=
targets=$(user_bin_targets)
dat_targets=

endif
man8_targets=$(addsuffix .8,$(targets))

all: check doc

check: $(addsuffix .chk,$(targets))

doc: stupidweasel.8

install: $(addprefix $(bindir)/,$(targets)) \
	$(mandir)/man8 \
	$(addprefix $(datdir)/,$(dat_targets)) \
	$(addprefix $(mandir)/man8/,$(man8_targets))
	for i in $(symlinks); do (cd $(bindir) && if [ ! -f "$$i" ]; then ln -sf stupidweasel "$$i"; elif [ ! -L "$$i" ]; then echo "$$i not installed because it is a file" >&2; elif [ stupidweasel != "`readlink "$$i"`" ]; then echo "$$i not installed because it is a symlink to a different command" >&2; fi ); done

$(bindir)/%: %
	perl -Tcw $< && install -m 755 $< $@

$(datdir):
	mkdir -p $@

$(datdir)/%: %
	install -m 644 $< $@

$(mandir)/man8:
	mkdir -p $@

$(mandir)/man8/%: %
	install -m 644 $< $@

mailpostgw: mailpostgw.in
	sed -e 's|@@NEWSUSER@@|$(mailpost_as)|g' -e 's|@@MAILPOST@@|$(mailpost)|g' -e 's|@@INPUT@@|$(datdir)/lists.dat|g' < $< > $@
	
%.chk: %
	perl -Tcw $<

%.8: %
	perl -nle 'print /^(=head1)(.*)/s? "$$1\U$$2": $$_' $< | pod2man --utf8 --section 8 -c 'System Management Manual' -n "$(shell echo "$*"|tr '[:lower:]' '[:upper:]')" > $@

.DELETE_ON_ERROR:
.PHONEY: all check doc install
