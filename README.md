Lightweight NodeJS Version Manager for UNIX systems
--

Requires:

One of `wget` or `curl`

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
