#!/bin/bash

# Clean the yum cache
rm -fr /var/cache/yum/*
/usr/bin/yum clean all

# Install needed packages
/usr/bin/yum install tar bzip2 kernel-devel-$(uname -r) kernel-headers perl gcc make elfutils-libelf-devel glibc

# Install Puppet Labs Official Repository for CentOS 7
/bin/rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm

# Install Puppet Server Components and Support Packages
/usr/bin/yum -y install puppetserver

# Remove the global Hiera.yaml
rm -f /etc/puppetlabs/puppet/hiera.yaml

# Start and Enable the Puppet Master
/usr/bin/systemctl enable puppetserver
/usr/bin/systemctl enable puppet

# Install Git
/usr/bin/yum -y install git

# Configure the Puppet Master
cat > /var/tmp/configure_puppet_master.pp << EOF
  #####                   #####
  ## Configure Puppet Master ##
  #####                   #####

ini_setting { 'Master Agent Server':
  section => 'agent',
  setting => 'server',
  value   => 'master.puppet.vm',
}

ini_setting { 'Master Agent CertName':
  section => 'agent',
  setting => 'certname',
  value   => 'master.puppet.vm',
}
EOF

# Bounce the network to trade out the Virtualbox IP
/usr/bin/systemctl restart network

# Place the r10k configuration file
cat > /var/tmp/configure_r10k.pp << 'EOF'
class { 'r10k':
  version => '3.4.1',
  sources => {
    'puppet' => {
#      'remote'  => 'https://git-codecommit.us-east-2.amazonaws.com/v1/repos/control_repo',
      'remote'  => 'https://github.com/SSCGATL/afl_control_repo',
      'basedir' => "${::settings::codedir}/environments",
      'prefix'  => false,
    }
  },
  manage_modulepath => false,
}
EOF

# Place the directory environments config file
cat > /var/tmp/configure_directory_environments.pp << 'EOF'
#####                            #####
## Configure Directory Environments ##
#####                            #####

# Default for ini_setting resource:
Ini_setting {
  ensure => 'present',
  path   => "${::settings::confdir}/puppet.conf",
}

ini_setting { 'Configure Environmentpath':
  section => 'main',
  setting => 'environmentpath',
  value   => '$codedir/environments',
}

ini_setting { 'Configure Basemodulepath':
  section => 'main',
  setting => 'basemodulepath',
  value   => '$confdir/modules:/opt/puppetlabs/puppet/modules',
}

ini_setting { 'Master Agent Server':
  section => 'agent',
  setting => 'server',
  value   => 'master.puppet.vm',
}

ini_setting { 'Master Agent Certname':
  section => 'agent',
  setting => 'certname',
  value   => 'master.puppet.vm',
}
EOF

# Install Puppet-r10k to configure r10k and all Dependencies
/opt/puppetlabs/puppet/bin/puppet module install -f puppet-r10k
/opt/puppetlabs/puppet/bin/puppet module install -f puppet-make
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-concat
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-stdlib
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-ruby
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-gcc
/opt/puppetlabs/puppet/bin/puppet module install -f puppet-make
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-inifile
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-vcsrepo
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-pe_gem
/opt/puppetlabs/puppet/bin/puppet module install -f puppetlabs-git
/opt/puppetlabs/puppet/bin/puppet module install -f gentoo-portage

# Now Apply Subsystem Configuration
/opt/puppetlabs/puppet/bin/puppet apply /var/tmp/configure_r10k.pp
/opt/puppetlabs/puppet/bin/puppet apply /var/tmp/configure_directory_environments.pp

# Install and Configure autosign.conf for agents
cat > /etc/puppetlabs/puppet/autosign.conf << 'EOF'
*.puppet.vm
EOF

# Initial r10k Deploy
/usr/bin/r10k deploy environment -pv

# Do Initial Puppet Run
/opt/puppetlabs/puppet/bin/puppet agent -t

# Enable Puppet Agent and Server for future Puppet runs
/usr/bin/systemctl start puppetserver
/usr/bin/systemctl start puppet
