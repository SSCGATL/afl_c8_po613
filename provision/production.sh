#!/bin/bash

# Install Puppet Labs Official Repository for CentOS 7
  /bin/rpm -Uvh https://yum.puppetlabs.com/puppet6-release-el-7.noarch.rpm

# Install Puppet Server Components and Support Packages
/usr/bin/yum -y install puppet-agent
/usr/bin/systemctl start puppet

# Restart Networking to Pick Up New IP
/usr/bin/systemctl restart network

# Create a puppet.conf
cat >> /etc/puppetlabs/puppet/puppet.conf << 'EOF'
certname = production.puppet.vm
server = master.puppet.vm
EOF

# Do initial Puppet Run
/opt/puppetlabs/puppet/bin/puppet agent -t

# Start Puppet Agent for future runs
/usr/bin/systemctl enable puppet
