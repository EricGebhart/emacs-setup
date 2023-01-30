
# My emacs setup. 

An old school emacs setup that uses packages. 
no _use-package_, just elpa, some config files and some extensions
outside of elpa.

## Chemacs

This configuration uses [Chemacs2](https://github.com/plexus/chemacs2) 
as an _Emacs bootloader_ to allow multiple emacs configurations
to exist at once.

This repo can do install the following:
__stable__ and __development__ installs of this emacs configuration. 
__OG__ for this repository, as well as __doom__ for 
[_doom-emacs](https://github.com/doomemacs), and __space__ for 
[spacemacs](https://github.com/syl20bnr/spacemacs).

On install, the target, `make chemacs-profiles` will create a 
full _~/.emacs-profiles.el_ with this repo being entered as the OG profile.

The default is to use the _stable_ install.  But when I modify my emacs configuration,
I use the _dev_ installation. Once _dev_ is pushed to github and I'm happy with it
I `git pull` a new _stable_ installation.

## Emacs-home

In the Makefile _emacs-home_ is set to __~/Emacs__ this is where all of the 
emacs installations will be placed.

## Installation

This is all new as I just added chemacs2 to the mix.

  * Fork this repository.
  * Check out your new repository.
  * `cd emacs-setup`

  #### This will move _.emacs_ and _.emacs.d_ out of the way if they exist.
  * `make install`  or `make install-all`
  
  __Install__ will install a stable/default configuraton, and
  will add this repo as a second configuration as __OG__.
  
  __install-all__ will add a _dev_ configuration, _Doom-emacs_ and _Spacemacs_.
  
  Configurations can also be installed individually.  Simple editing 
  of ~/.emacs-profiles.el will be necessary if installing later.

  `make install-stable install-dev install-spacemacs install-doom`

### Finish each configuration's install

  The installs for each emacs configuraton installation need to be run in 
  order for them to install their packages the first time.
  
  Note: This is where things might fail if a package is missing from packages.el 
  or a theme has been deleted from __elpa__.
  
      make finish-install 

  Will run Emacs here, `--with-profile OG`, and then with the 
  installations that exist in 
 _emacs-home_ with the _stable_, _dev_ and _space_ profiles for the first time. 

  It will then execute __doom/bin/doom install__ to install doom packages.
  This can take a bit for each one to finish and they are taking some space
  as each one has its own __elpa__.
      
  Or you can do it as you go with:

   - `emacs` --with-profile stable --with-debug-init
   - `emacs --with-profile dev`
   - `emacs --with-profile space`
   - `emacs --with-profile OG`

   or similarly:
   - `emacsn -p <profile name>`
    
  Doom, does need to have it's install run.
      - `~/Emacs/doom/bin/doom install`


## Managing elisp development

I use these installs to insure I always have a way to do work if I have
broken anything.  I do my elisp work in dev.  When dev is working well and 
everything is pushed I __make update-stable__ to do a `git pull` and bring 
it up to date.

### Emacs boot choices

The boot profile choices are defined in __~/.emacs-profiles__

Emacs profile choices are:
 - stable, default
 - dev
 - doom
 - space
 - OG  - This repo maybe. The original emacs-setup repo installed from. 
 
Emacs will default to _stable_ but can be redirected with

    emacs --with-profile dev

or 

    emacsn -p dev

## The emacsn script

I run emacs a few different ways. I use named daemons for some things.
its nice to have so clients can be used for mu4e and Exwm.

To facilitate the emacs commandline
I have a wrapper for emacs in my ~/bin directory.  `emacsn`.
It is a simple CLI that does all of those things. 

`emacsn -h`  will give extensive help with examples.

### emacs daemons, clients, exwm

It runs `mu4e` or my `main-window` function to set up emacs in a 
standard configuration for a project. 
It knows how to run any elisp function on startup, 
it can choose different Chemacs profiles.  Creating multiple daemons
and using them by name is easy.
It's easy to add others. It's available in my
(my dotfiles repo)[http://github.com/EricaLinaG/dotfiles]

The __emacsn__ script has extensive help and a lot of options. It is
simpler than emacs it's self.;


## What is here.

*I think* This is a pretty straight forward setup. 

There is an _elisp_ directory full of stuff, mostly configurations and
extensions which I wrote or borrowed from someone else that aren't available
as packages. Initialization happens in _elisp/init.el_


## The big things; 

- Evil-mode (which can be easily switched off in _elisp/setup.el_).
- Modus themes.
- Lots of Hydras.
- Org
- Mu4e
- PosFrame

I program lots of languages, these are the main ones. They may or may not
have extended configurations from default. 

- Languages:
  - C, C++
  - Clojure
  - Clojure script
  - Python
  - Lua
  - Haskell
  - Lisps - Scheme, Guile, Rackett, etc.
   
#### Ivy, Ido, Helm, Vertico, etc.

I've used pretty much all the helpers over the years, ivy, ido, smex, helm, vertico.
Currently using vertico. Configurations are still there for the others.

## Key Files

Look in elisp/:
  - packages.el - lists all packages to load

  - config/ - Folder where all the real setup goes.
  - extensions/ - Folder where non-elpa custom code goes.

  - config/vars.el - miscellaneous variable setting.
  - config/keys.el - key bindings, mostly F keys.
  - config/evil-leader.el - more key bindings, vi style.

Look in _packages.el_ if I happen to add a package through _package-install_ 
I then go add it to _packages.el_ so I won't forget and configuration is repeatable. 
If I forget, the next fresh install will likely fail with package not installed.

## Natural Languages

I have been studying French for the last few years.
Now studying Italian. Working on replacing Anki with Org drill in my routine.

I can also see that I'll probably want to add another language or two in the 
future. So I've been working to tap into the language capabilities of
emacs. I have a nice function to switch between input methods and dictionaries.
Ispell, flyspell, and hunspell are all working together for spell checking.
Google translate is there for highlighted text, current word, or sentence at point
and Language Tool is there to check grammar. Take a look at the language sub-menu
in _evil-leader-conf.el_ even if you are going to turn off evil-mode. Check out
_elisp/extensions/language.el_ and _elisp/config/lang-config.el_ and 
_google-translate-conf.el_

## Mu4e - Mail

Note:  Need to test __pacman__ installation, might be super simple now.

_Mu4e_ I use mu4e for email. I can't imagine a better email client. There is a
reasonably basic mu4e configuration with multiple contexts. There is a sample mbsyncrc
file that can be used to configure _isync/mbsync_.  I have a separate _.emacs-mu4e_ 
startup file for running an mu4e emacs instance in a terminal, it combines _.emacs_
and _elisp/setup.el_ into a single startup that is specifically for email in a terminal.

This is a bit easier now than it used to be. Arch Linux seems to install it properly
when _mu_ is installed with pacman.

Everything that can be installed as packages is. *The glaring exception is mu4e.*
see this page about (installing mu/mu-git/mu4e)[https://www.djcbsoftware.nl/code/mu/mu4e/Installation.html#Installation].  There is a make rule that works to get everthing wired up on Arch Linux. YMMV.

## Keymappings

I didn't mess with key mappings except for F keys. 
My <leader> key is currently __,__ but I am looking to change to __SPC__ and also to
do something similar to doom-emacs and spacemacs so that everything is available 
outside of evil-mode.

I have an extensive menu system on Evil-leader which allows for __,w__ for write, 
__,q__ delete-buffer, etc. the entire Hydra subsystem is available at <leader> h.

I use _which-key-posframe_ which is almost like hydra with all the submenus. 

Mostly, the key mappings I added are non-intrusive.  It is definitely a
good idea to go read _config/evil-leader-conf.el_ whether you want _Evil_ key
bindings or not. It will give you a good idea of functionality to look for or map
to your own keys in _keys.el_

# Additional packages needed

See my [arch-pkgs repo](http://github.com/ericalinag/arch-pkgs) for an easy way to install
everything you need.

 * For email
    * mu-git - on Arch linux
    * isync (mbsync) 

 * for Spelling and grammar.
    * languagetool 
    * hunspell -- add dictionaries as needed. 
    * hunspell dictionaries  [get them here!](https://github.com/EricGebhart/Hunspell-dictionaries)
    or just do `pacman -Ss hunspell` to see what arch has.

 - Fonts
  *Iosevka Fonts* 
  [They are here](https://github.com/be5invis/Iosevka)
  Or just install the Arch Linux packages.  `yay -S ttf-iosevka ttc-iosevka`

Additional isync/mbsync/mu4e resources [are here:] (http://www.ict4g.net/adolfo/notes/2014/12/27/EmacsIMAP.html)



## stuff, to verify and maybe chuck from here down.

__*This is currently not necessary*__ 
  it is installed with the __prepare-install__ target. I do also wonder about the current state of the automatic install of mu4e with the package install of mu.

* `make mbsync` to copy a sample _.mbsyncrc_ for use with _isync_ to your home directory. 
* (install mu/mu-git/mu4e)[https://www.djcbsoftware.nl/code/mu/mu4e/Installation.html#Installation]
  or maybe just do a `yay -S mu-git` if you are on Arch.

* Possibly copy or link the newly installed mu4e elisp to _elisp/extensions/mu4e_. 
  Or add it to your load path. It's probably in _/usr/share/emacs/site-lisp_. that's where
  it is on Arch Linux.
  Alternatively you could add it to your load path.
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
  Or it may just work.
  Or possibly try `make mu4e` it might will probably worku On Arch Linux it does.

* install hunspell, languagetool and hunspell dictionaries as desired.


Evil Mode
=========
I've been using emacs in some sort of Vi emulation since 1995. Evil-mode is, IMHO the best vi emulator so far. Although neovim is doing a really good job. vimscript is an unfortunate language.
You can easily turn it off in _setup.el_ . The Evil mode setup includes a few but not all of the Evil-mode extensions. For more information check out the [Evil-mode documentation.](http://www.emacswiki.org/emacs/Evil)

Included along with evil mode are: 
* [evil-leader](https://github.com/cofi/evil-leader)
* [evil-paredit](https://github.com/roman/evil-paredit)
* [evil-nerd-commenter](https://github.com/redguardtoo/evil-nerd-commenter)
* [evil-surround](https://github.com/timcharper/evil-surround)
* evil-org
* undo-tree
 
CycleBufs
==============
I don't use this anymore. I'm currently switching to perspective which
works well with projectile and Exwm.

Cyclebufs is now built on top of BS - Buffer Selection. There are several bs-configurations,
and extra functionality which makes switching buffers more contextual. 
Reusing windows for different mode groups shell, dired, and bs-show if they are visible.

Also cycling of buffers based on groups.

As an example, the shell group contains shell, eshell, ansi-term, cider, and inferior python modes.
Once a buffer has one of the modes in the group, cycling will stay within that group.
There is also contextual cycling based on the mode group of the current buffer, 
cycling through shells, *buffers, or file buffers accordingly. 

Cyclebufs will open a shell buffer of your choice based on the value of cb-shell-command. The default is
eshell. See *vars.el*.  


## Themes
I am using Modus Themes now. There are lots of other themes here,
but I'm tempted to remove all but my custom theme extensions.
They frequently are deleted from elpa and cause trouble during install
with package not found errors. The name must then be removed from packages.el.

Lots of themes from packages. Additionally my own personal theme
strange-deeper-blue. As well as a couple of variations on solarized.
There is also a palette-themes.el which is a more general library
adapted from the solarized-theme. Palette-themes allow for the creation
of themes simply by defining a palette of colors. There are four
different variations of the solarized themes included.
