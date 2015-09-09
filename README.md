Lightweight NodeJS Version Manager for UNIX systems
--
Lets you quickly switch between node versions, list all existing version and remove ones that you don't want any more

Requires:

One of `wget` or `curl` (and the Perl module `HTML::TreeBuilder` if you want to use `nman_list` command - `cpan install HTML::TreeBuilder`).

For OSX, you'll need the xcode command line tools (so that you get `gcc`, `g++`` and `make`), for Linux, you'll need `gcc`, `g++`` and `make` (on Ubuntu, you can `sudo apt-get install gcc, g++, make`).  Additionally, if you're using OSX and you'd rather use `wget` than `curl` then you're best off installing `homebrew` and then using that to install `wget` (building it from source on OSX is a pain in the arse).

To use:

`curl -O https://raw.githubusercontent.com/jonboydell/nman/master/node-manager.sh; source node-manager.sh;`

To add functions from `node-manager.sh` permanently:

1. Copy the `node-manager.sh` file somewhere useful
2. Add `source <path_to>/node-manager.sh` into your `.profile` (in your $HOME directory)
2. Add `nman-switch-active` into your .profile too

Commands:

* `nman-switch <VERSION_NUMBER>` - Switches to a new version of NodeJS (Downloads and installs it, if necessary
* `nman-remove <VERSION_NUMBER>` - Permanently removes an installed version of NodeJS
* `nman-list` - List of all available versions
* `nman-installed` - List of all installed versions

Issues:

1. node js PATH isn't persisted across user sessions, you have to run `nman-switch <version>` for each session.
2. `nman-switch <version>` works, but also shows an warning/error that can be ignored but needs to be removed.
