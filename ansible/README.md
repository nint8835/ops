# Usage

Usage of these playbooks & roles assumes you have already completed the following steps:

* Installed a Debian 10 install with SSH available
* Named the second user created during install `debian`
* Have copied an SSH key for that user to the server
* Have configured sudo
  * `su -`
  * `apt-get install sudo`
  * `usermod -aG sudo debian`
* Passwordless sudo is enabled
  * `visudo`
  * Update the `ALL` in the `%sudo` line to `NOPASSWD:ALL`
* XCP-ng Tools are installed
  * https://xcp-ng.org/docs/guests.html#supported-linux-distributions
* `python-apt` is installed
  * `apt-get install python-apt`
