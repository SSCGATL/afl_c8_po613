#OSX Installation Instructions

###Required Software

**Download and Install Vagrant**

	https://www.vagrantup.com/downloads.html

Note: Vagrant 2.2.7 and VirtualBox 6.1.4 r136177 don't play nicely together. Use Vagrant 2.2.6.

**Download and Install VirtualBox**

	https://virtualbox.org

**Install Git**

If it isn't already installed, install Git via the Apple Command Line Utilities from Apple's https://developer.apple.com website.

If you're using HomeBrew, you can install there via `brew install git` as well.

**Install Vagrant Plugins**

Install each product according to its instructions.  When complete, install the required plugins into Vagrant via Vagrant's plugin manager:

	vagrant plugin install vagrant-hosts
	vagrant plugin install vagrant-pe_build
	vagrant plugin install vagrant-vbguest

**To Test to ensure the plugins were installed properly:**

	vagrant plugin list

**Create a Workspace and Clone this Repository**

	mkdir -p ~/Projects/Vagrant
	cd ~/Projects/Vagrant
	git clone https://github.com/SSCGATL/afl_c8_po613.git

**Change to the Directory and Lauch Vagrant**

	cd ~/Projects/Vagrant/afl_c8_po613
	vagrant up

At this point, if everything is in order, your system will begin to orchestrate Virtualbox to create all the needed VMs, download the VM images, Puppet Community, and will configure the client machines, connect them to the master, configure R10k, the console, and prepare your environment for use.

**Notes**

Since this is Puppet Community, there is no console. To connect to a system, from the afl_c8_po613 directory (the location of the Vagrantfile) you can type `vagrant ssh <hostname>` and you will land in that system as the "vagrant" user. If need be, you can escalate privileges with `sudo su -`.

You are expected to know and understand command line, site.pp, or external node or Hiera classification to be able to manipulate the classes assigned to a given node.
