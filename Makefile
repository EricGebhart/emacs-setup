emacs-home := ~/Emacs

move-dot-emacs := $(or $(and $(wildcard $(HOME)/.emacs),1),0)
move-dot-emacs.d := $(or $(and $(wildcard $(HOME)/.emacs.d),1),0)
seconds-now := $(date +%s)


.PHONY: install
install: links

.PHONY: mu4e
mu4e:
	cp -r ~/.cache/yay/mu-git/src/mu/mu4e $(HOME)/elisp/extensions/

.PHONY: mbsync
mbsync:
	ln -s $(PWD)/mbsyncrc $(HOME)/.mbsyncrc

.PHONY: links
links: mbsync

clean-links:
	rm $(HOME)/.mbsyncrc

# copy .emacs-profiles.el to ~/
.PHONY: chemacs-profiles
chemacs-profiles:
	cat .emacs-profiles.el
	printf "\n\n\n"
	cp .emacs-profiles.el ~/


install-emacsn:
	cp emacsn ~/bin/

touch-custom:
	touch ~/.config/emacs-custom.el

mk-emacs-home: touch-custom
	printf "Creating Emacs Home: $(emacs-home)\n"
	mkdir -p $(emacs-home)

.PHONY: mv.emacs
mv.emacs:
ifneq ($(move-dot-emacs), 0)
	ls -l ~/.emacs
	printf "Moving ~/.emacs\n"
	mv ~/.emacs ~/.emacs.bak.$(seconds-now)
endif

.PHONY: mv.emacs.d
mv.emacs.d:
ifneq ($(move-dot-emacs.d), 0)
	ls -l ~/.emacs.d
	printf "Moving ~/emacs.d\n"
	mv ~/.emacs.d ~/.emacs.d.bak.$(seconds-now)
endif

# move with preserve dot emacs.
.PHONY: backup-dot-emacs
backup-dot-emacs:  mv.emacs.d mv.emacs

# scorch dot emacs.
remove-dot-emacs:
	rm -rf ~/.emacs.d
	rm -f ~/.emacs

# Create a new Chemacs profiles with this repo as OG
.PHONY: add-og
add-og:
	touch .emacs-profiles.el
	printf "Adding profile for OG\n\n"
	sed 's:FIXME:$(PWD):' emacs-profiles-orig.el > .emacs-profiles.el

# Chemacs goes in emacs.d
install-chemacs:
	git clone https://github.com/plexus/chemacs2.git ~/.emacs.d

# profile targets, and a generic rule to add them into .emacs-profiles.el.
profiles := OG gnu stable dev test doom space prelude
$(profiles):
	printf "Adding profile for $@\n\n"
	sed 's/;;$@//' .emacs-profiles.el > tmp
	mv tmp .emacs-profiles.el

# Add a gnu profile. Nothing to do really. Point at an empty emacs.d.
add-gnu: gnu
	mkdir -p $(emacs-home)/gnu

# everyone else goes in emacs home.
install-doom: doom
	git clone https://github.com/hlissner/doom-emacs $(emacs-home)/doom
	$(emacs-home)/doom/bin/doom install

install-spacemacs: space
	git clone https://github.com/syl20bnr/spacemacs $(emacs-home)/space

install-prelude: prelude
	git clone https://github.com/bbatsov/prelude.git $(emacs-home)/prelude

install-test: test
	git clone https://github.com/ericalinag/emacs-setup $(emacs-home)/test

remove-test:
	rm -f $(emacs-home)/test

install-dev: dev
	git clone https://github.com/ericalinag/emacs-setup $(emacs-home)/dev

install-stable: stable
	git clone https://github.com/ericalinag/emacs-setup $(emacs-home)/stable

all: mu4e install-all

# not sure about mu4e installation at this point. I think it just works now.
# I need to test that.

# prepare for install
# remove .mbsync, move ~/.emacs, ~/.emacs.d, mkdir emacs home.
prepare-install: clean-links backup-dot-emacs mk-emacs-home

# prepare and install links, emacsn, chemacs, chemacs profiles
install: prepare-install links install-emacsn add-og add-gnu\
	install-chemacs chemacs-profiles

# prepare and install everything we have.
# the install plus: stable, dev, doom, and space emacs.
# dont install test, but put it into the profiles.
install-all: install install-stable install-dev test\
	install-spacemacs install-prelude install-doom chemacs-profiles

# test a fresh install from github.
test-install: remove-test install-test
	emacs --with-profile test

finish-message := "\n\nThis will run each emacs profile in turn.\n There will be \
interactions and you will need to\n\n close each emacs\n\n with C-x C-c for the make \
process to continue.\n\n"

# except for doom, just run an instance of each and let them load themselves.
finish-install:
	printf $(finish-message)
	emacs --with-profile OG
	[ -d $(emacs-home)/stable ] && emacs --with-profile stable
	[ -d $(emacs-home)/dev ] && emacs --with-profile dev
	[ -d $(emacs-home)/space ] && emacs --with-profile space
	[ -d $(emacs-home)/prelude ] && emacs --with-profile prelude
