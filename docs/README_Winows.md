# Windows Installation Instructions

### Required Software

**Download and Install Vagrant**

https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.msi	

**Download and Install Virtualbox**

	https://download.virtualbox.org/virtualbox/6.0.4/VirtualBox-6.0.4-128413-Win.exe

**Download and Install Git for Windows**

	https://github.com/git-for-windows/git/releases/download/v2.20.1.windows.1/Git-2.20.1-64-bit.exe

**Download and Install Visual Studio Code**

	https://code.visualstudio.com/Download

**Install Vagrant Plugins**

Install each product according to its instructions.  When complete, install the required plugins into Vagrant via Vagrant's plugin manager:

	vagrant plugin install vagrant-hosts
	vagrant plugin install vagrant-pe_build
	vagrant plugin install vagrant-vbguest

**Windows PE Download Notes**

In previous releases, vagrant-pe_build had issues with downloading Puppet Enterprise for installation onto the VMs.  In recent documentation, the project has stated that this bug is fixed, but I have as of yet not had the opportunity to test it.  If your instance comes up without further assistance, then your instalation will be complete at this point.

In the past, you would need to download the Windows Package manually here:

	http://downloads.puppetlabs.com/windows/puppet6/puppet-agent-6.14.0-x64.msi


**Create a Workspace and Clone this Repository**

In Windows Explorer, navigate to a location within which to create your project.  From there, clone the git repository.

	git clone https://github.com/cvquesty/afl_c8_po613.git

**Change to the Directory and Launch Vagrant**

	cd afl_c8_po613
	vagrant up

**Notes:**

* This environment requires your machine to have at least 8GB of RAM.
* This has been tested to work in Windows 8.1.
