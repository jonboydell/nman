Lightweight NodeJS Version Manager for UNIX systems
--
Lets you quickly switch between node versions, list all existing version and remove ones that you don't want any more

Requires:

One of `wget` or `curl`.  

*If you are using OSX, and you want to use `wget` then your best bet is to install `brew` and then use that to install `wget`.  Mainly because building `wget` from source is a pain in the arse (as is building many useful tools on OSX).

To use:

`curl -O https://raw.githubusercontent.com/jonboydell/nman/master/node-manager.sh; source node-manager.sh;`

To add functions from `node-manager.sh` permanently:

1. Copy the `node-manager.sh` file somewhere useful
2. Add `source <path_to>/node-manager.sh` into your `.profile` (in your $HOME directory)

Commands:

* `nman-switch <VERSION_NUMBER>` - Switches to a new version of NodeJS (Downloads and installs it, if necessary
* `nman-remove <VERSION_NUMBER>` - Permanently removes an installed version of NodeJS
* `nman-list` - List of all available versions
* `nman-installed` - List of all installed versions

Issues:

1. node js PATH isn't persisted across user sessions, you have to run `nman-switch <version>` for each session.
2. `nman-switch <version>` works, but also shows an warning/error that can be ignored but needs to be removed.
