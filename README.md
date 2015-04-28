Lightweight NodeJS Version Manager for UNIX systems
--

Problems:
* Currently only works on OSX systems with wget installed (annoying)

To use:

`curl -O https://raw.githubusercontent.com/jonboydell/nman/master/node-manager.sh; source node-manager.sh;`

Commands:

* `nman-switch <VERSION_NUMBER>` - Switches to a new version of NodeJS (Downloads and installs it, if necessary
* `nman-remove <VERSION_NUMBER>` - Permanently removes an installed version of NodeJS
* `nman-list` - List of all available versions
* `nman-installed` - List of all installed versions
