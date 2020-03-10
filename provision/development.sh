#!/bin/bash

# Install Puppet Labs Official Repository for CentOS 7
  /bin/rpm -Uvh https://yum.puppetlabs.com/puppet6-release-el-7.noarch.rpm

# Install Puppet Agent Components and Support Packages
/usr/bin/yum -y install puppet-agent

# Restart Networking to Pick Up New IP
/usr/bin/systemctl restart network

# Create a puppet.conf
cat >> /etc/puppetlabs/puppet/puppet.conf << 'EOF'
certname = development.puppet.vm
server = master.puppet.vm
EOF

# Do initial Puppet Run
/opt/puppetlabs/puppet/bin/puppet agent -t

# Start Puppet Daemon for future runs
/usr/bin/systemctl enable  puppet
/usr/bin/systemctl start puppet
